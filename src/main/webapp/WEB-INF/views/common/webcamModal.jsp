<div class="modal fade" id="webcamModal" tabindex="-1" aria-labelledby="webcamModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="webcamModalLabel">
                    <i class="fas fa-camera"></i> Capture Photo
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="webcam-container">
                    <video id="webcamVideo" autoplay playsinline style="width: 100%; max-width: 500px; height: auto; border-radius: 8px;"></video>
                    <canvas id="webcamCanvas" style="display: none;"></canvas>
                    <div class="webcam-controls">
                        <button type="button" id="captureBtn" class="btn btn-primary">
                            <i class="fas fa-camera"></i> Capture Photo
                        </button>
                        <button type="button" id="retakeBtn" class="btn btn-secondary" style="display: none;">
                            <i class="fas fa-redo"></i> Retake
                        </button>
                    </div>
                    <div class="webcam-preview" id="webcamPreview" style="display: none;">
                        <img id="capturedImage" style="width: 100%; max-width: 500px; height: auto; border-radius: 8px;">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" id="usePhotoBtn" class="btn btn-primary" style="display: none;">
                    <i class="fas fa-check"></i> Use This Photo
                </button>
            </div>
        </div>
    </div>
</div> 