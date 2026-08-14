#!/usr/bin/env python3
"""Generate bulk CSV seed data (10k leads, 500 accounts, 100 reps, 50 beats)."""
import csv
from pathlib import Path

out = Path(__file__).parent / "generated"
out.mkdir(exist_ok=True)

def w(name, headers, rows):
    with (out / name).open("w", newline="") as f:
        wr = csv.DictWriter(f, fieldnames=headers)
        wr.writeheader()
        wr.writerows(rows)

w("Territory__c.csv", ["Code__c", "Region__c", "City__c", "State__c", "Is_Active__c"],
  [{"Code__c": f"T{i:03d}", "Region__c": ["North","South","East","West","Central"][i % 5],
    "City__c": f"City{i}", "State__c": "ST", "Is_Active__c": "true"} for i in range(1, 21)])
w("Account.csv", ["Name", "BillingCity"],
  [{"Name": f"Outlet {i:04d}", "BillingCity": f"City{i % 20 + 1}"} for i in range(1, 501)])
w("Lead.csv", ["LastName", "Company", "Status", "City", "Source_Channel__c", "Customer_Segment__c"],
  [{"LastName": f"Lead{i}", "Company": f"Co{i}", "Status": "Open - Not Contacted",
    "City": f"City{i % 20 + 1}", "Source_Channel__c": ["Web","Call_Center","Campaign","Partner","Mobile_App"][i % 5],
    "Customer_Segment__c": ["GOLD","SILVER","BRONZE"][i % 3]} for i in range(1, 10001)])
print("Wrote", out)
