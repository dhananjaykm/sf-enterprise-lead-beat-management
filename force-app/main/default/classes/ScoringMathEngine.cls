/**
 * CPU-heavy recursive decay used by batch scoring.
 * MIGRATION: E / G — Do Not Migrate to Flow.
 */
public with sharing class ScoringMathEngine {
    public static Decimal recursiveDecay(Decimal value, Integer depth) {
        if (depth <= 0 || value == null) {
            return value == null ? 0 : value;
        }
        Decimal next = value * 0.97 + Decimal.valueOf(Math.sin(Double.valueOf(value)));
        return recursiveDecay(next, depth - 1);
    }

    public static Decimal optimizeBeatLoad(List<Decimal> loads, Integer iterations) {
        if (loads == null || loads.isEmpty()) {
            return 0;
        }
        Decimal best = 999999;
        for (Integer i = 0; i < iterations; i++) {
            Decimal acc = 0;
            for (Decimal load : loads) {
                acc += (load - Decimal.valueOf(i)).pow(2);
            }
            if (acc < best) {
                best = acc;
            }
        }
        return best;
    }
}
