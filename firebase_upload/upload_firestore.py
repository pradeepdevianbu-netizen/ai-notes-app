import pandas as pd
import firebase_admin
from firebase_admin import credentials, firestore

# Firebase Service Account Key
cred = credentials.Certificate("")
firebase_admin.initialize_app(cred)

db = firestore.client()

# -----------------------------
# Upload Colleges
# -----------------------------
colleges = pd.read_csv("colleges.csv")

for _, row in colleges.iterrows():
    db.collection("colleges").document(str(row["collegeId"])).set({
        "collegeName": row["collegeName"],
        "district": row["district"],
        "university": row["university"],
        "collegeType": row["collegeType"],
        "status": row["status"],
    })

print("✅ Colleges Uploaded")

# -----------------------------
# Upload Departments
# -----------------------------
departments = pd.read_csv("departments.csv")

for _, row in departments.iterrows():
    db.collection("departments").add({
        "collegeId": row["collegeId"],
        "departmentName": row["departmentName"],
        "duration": int(row["duration"]),
    })

print("✅ Departments Uploaded")