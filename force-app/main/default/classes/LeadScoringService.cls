/**
 * Weighted scoring using CMDT plus a non-linear engagement curve.
 * MIGRATION: D — simple weights could be Flow formulas; curve/model remains Apex.
 */
public with sharing class LeadScoringService {
    public static void score(List<Lead> leads) {
        Map<String, Decimal> weights = loadWeights();
        List<Lead_Score__c> scores = new List<Lead_Score__c>();
        for (Lead l : leads) {
            Decimal firm = firmographic(l) * (weights.containsKey('FIRMOGRAPHIC') ? weights.get('FIRMOGRAPHIC') : 0.35);
            Decimal eng = engagement(l) * (weights.containsKey('ENGAGEMENT') ? weights.get('ENGAGEMENT') : 0.40);
            Decimal src = sourceBoost(l) * (weights.containsKey('SOURCE') ? weights.get('SOURCE') : 0.25);
            Decimal total = (firm + eng + src).setScale(2);
            l.Lead_Score_Value__c = total;
            if (l.Id != null) {
                scores.add(new Lead_Score__c(
                    Lead__c = l.Id,
                    Total_Score__c = total,
                    Firmographic_Score__c = firm,
                    Engagement_Score__c = eng,
                    Model_Version__c = 'v3-legacy',
                    Scored_On__c = Datetime.now()
                ));
            }
        }
        if (!scores.isEmpty()) {
            insert scores;
        }
    }

    private static Map<String, Decimal> loadWeights() {
        Map<String, Decimal> weights = new Map<String, Decimal>();
        for (Lead_Scoring_Weight__mdt w : [
            SELECT Factor__c, Weight__c, Is_Active__c FROM Lead_Scoring_Weight__mdt WHERE Is_Active__c = true
        ]) {
            weights.put(w.Factor__c, w.Weight__c);
        }
        return weights;
    }

    private static Decimal firmographic(Lead l) {
        Decimal revenue = l.AnnualRevenue == null ? 0 : l.AnnualRevenue;
        return Math.min(100, (revenue / 100000).intValue());
    }

    /**
     * Non-linear curve — not a Flow formula candidate.
     * MIGRATION: E for this method.
     */
    private static Decimal engagement(Lead l) {
        Integer touches = l.NumberOfEmployees == null ? 1 : Integer.valueOf(l.NumberOfEmployees);
        Double x = Math.min(50, touches);
        return Decimal.valueOf((1 - Math.exp(-0.12 * x)) * 100);
    }

    private static Decimal sourceBoost(Lead l) {
        if (l.Source_Channel__c == 'Partner') {
            return 90;
        }
        if (l.Source_Channel__c == 'Campaign') {
            return 70;
        }
        return 40;
    }
}
