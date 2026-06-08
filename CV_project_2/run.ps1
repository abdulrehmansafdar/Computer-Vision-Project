# Railway Track Defect Detector - Setup & Run
#
# Prerequisites:
#   1. Install uv:  https://docs.astral.sh/uv/
#   2. Train the model OR download a pre-trained best.pt
#      Place best.pt and class_names.json in webapp/model/
#
# Steps:
param(
    [switch]$Setup,
    [switch]$Run
)

if (-not $Setup -and -not $Run) {
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\run.ps1 -Setup    # Create venv and install dependencies with uv"
    Write-Host "  .\run.ps1 -Run      # Start the FastAPI web app"
    exit
}

if ($Setup) {
    Write-Host "==> Creating virtual environment with uv..." -ForegroundColor Cyan
    uv venv

    Write-Host "==> Installing dependencies..." -ForegroundColor Cyan
    uv pip install -r requirements.txt

    Write-Host "==> Setup complete!" -ForegroundColor Green
    Write-Host "    Next: Place best.pt and class_names.json in webapp/model/"
    Write-Host "    Then: .\run.ps1 -Run"
}

if ($Run) {
    if (-not (Test-Path "webapp/model/best.pt")) {
        Write-Host "ERROR: Model not found at webapp/model/best.pt" -ForegroundColor Red
        Write-Host "Train the model using training/railway_defect_trainer.ipynb in Google Colab" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "==> Starting Railway Track Defect Detector..." -ForegroundColor Cyan
    Write-Host "    Open http://localhost:8000 in your browser" -ForegroundColor Green
    uv run uvicorn webapp.main:app --host 0.0.0.0 --port 8000 --reload
}
