import subprocess, time, requests, os, sys, signal

PORT = 8001
BASE_DIR = r"D:\UET\6th_semester\projects\CV_project_2"

# Start server on alternative port
proc = subprocess.Popen(
    ["uv", "run", "uvicorn", "webapp.main:app", "--host", "0.0.0.0", "--port", str(PORT)],
    cwd=BASE_DIR,
    stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    creationflags=subprocess.CREATE_NEW_PROCESS_GROUP
)

# Wait for server
for i in range(20):
    time.sleep(1)
    try:
        r = requests.get(f"http://localhost:{PORT}/", timeout=3)
        if r.status_code == 200:
            print(f"Server ready on port {PORT}")
            break
    except:
        pass
else:
    print("Server failed to start")
    stdout, stderr = proc.communicate(timeout=5)
    print(f"stdout: {stdout.decode()[:500]}")
    print(f"stderr: {stderr.decode()[:500]}")
    exit(1)

# Test with synthetic image
test_img = os.path.join(BASE_DIR, "test_defect.jpg")
with open(test_img, "rb") as f:
    r = requests.post(f"http://localhost:{PORT}/predict", files={"file": ("test.jpg", f, "image/jpeg")}, timeout=30)

data = r.json()
print(f"\nStatus: {r.status_code}")
print(f"Total defects detected: {data['total_defects']}")
print(f"Detections: {data['detections']}")

if data['total_defects'] > 0:
    print(f"\nAnnotated: http://localhost:{PORT}/uploads/{data['annotated_filename']}")
    print("✅ TEST PASSED - Model detected defects!")
else:
    print("⚠️  No defects (test image is synthetic, expected)")

# Test original
print(f"\nOriginal image: http://localhost:{PORT}/uploads/{data['filename']}")

proc.terminate()
time.sleep(1)
try: proc.kill()
except: pass
print("\nServer stopped.")
