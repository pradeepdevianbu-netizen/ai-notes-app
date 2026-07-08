import pandas as pd
import firebase_admin
from firebase_admin import credentials, firestore

# Firebase Service Account Key
cred = credentials.Certificate("serviceAccountKey.json.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# -----------------------------
# Upload Colleges
# -----------------------------
colleges = pd.read_csv("Engineering_colleges_master - collages.csv")

for _, row in colleges.iterrows():
    db.collection("colleges").document(row["collegeId"]).set({
        "collegeName": row["collegeName"],
        "district": row["District"],
        "university": row["University"],
        "collegeType": row["CollegeType"],
        "status": row["Status"],
    })

print("✅ Colleges Uploaded")

# -----------------------------
# Upload Departments
# -----------------------------
departments = pd.read_csv("Engineering_colleges_master - departments.csv")

for _, row in departments.iterrows():
    db.collection("departments").add({
        "collegeId": row["collegeId"],
        "departmentName": row["departmentName"],
        "duration": int(row["duration"]),
    })

print("✅ Departments Uploaded")