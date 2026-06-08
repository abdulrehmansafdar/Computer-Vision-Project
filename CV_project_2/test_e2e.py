"""Start server, test prediction endpoint, then stop."""
import subprocess, time, requests, sys, os

PORT = 8000
BASE_DIR = r"D:\UET\6th_semester\projects\CV_project_2"
venv_python = os.path.join(BASE_DIR, ".venv", "Scripts", "python.exe")

# Start server
proc = subprocess.Popen(
    [venv_python, "webapp/main.py"],
    cwd=BASE_DIR,
    stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    creationflags=subprocess.CREATE_NEW_PROCESS_GROUP
)

# Wait for server
for i in range(15):
    time.sleep(1)
    try:
        r = requests.get(f"http://127.0.0.1:{PORT}/", timeout=3)
        if r.status_code == 200:
            print(f"Server ready (attempt {i+1})")
            break
    except requests.ConnectionError:
        pass
else:
    print("Server failed to start")
    stdout, stderr = proc.communicate(timeout=5)
    print("stdout:", stdout.decode()[:300])
    print("stderr:", stderr.decode()[:300])
    sys.exit(1)

# Test prediction with synthetic image
test_img = os.path.join(BASE_DIR, "test_defect.jpg")
print(f"Testing with: {test_img} ({os.path.getsize(test_img)} bytes)")

with open(test_img, "rb") as f:
    r = requests.post(f"http://127.0.0.1:{PORT}/predict", files={"file": ("test.jpg", f, "image/jpeg")}, timeout=30)

data = r.json()
print(f"\nStatus: {r.status_code}")
print(f"Defects found: {data['total_defects']}")

for d in data['detections']:
    print(f"  - {d['class']} ({d['confidence']*100:.0f}%)")

if data['total_defects'] > 0:
    print(f"\nAnnotated: http://127.0.0.1:{PORT}/uploads/{data['annotated_filename']}")
    print("✅ DETECTION WORKING")
else:
    print("⚠️  No defects (synthetic image, expected)")

# Cleanup
proc.terminate()
time.sleep(1)
proc.kill()
print("\nServer stopped.")
