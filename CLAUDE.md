# DR Screening App — Project Context

Building a Flutter app for doctors to screen patients for Diabetic Retinopathy.
7-day MVP sprint. Offline-first: everything must work with zero network connection.

## Data model (build in this order)
- Patient: id, name, age, gender, phone, created_at
- Visit: id, patient_id, visit_date, eye_side, notes
- Image: id, visit_id, local_file_path, source ('uploaded' or 'captured'), timestamp
- Diagnosis: id, image_id, prediction, confidence, model_version

## Tech stack
- Flutter + sqflite (local SQLite database, NOT drift/firebase for now)
- Firebase Auth (email/password) — added Day 2
- tflite_flutter — added Day 5
- image_picker — added Day 4

## Current sprint day: Day 1
