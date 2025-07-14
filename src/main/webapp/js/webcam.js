// src/main/webapp/js/webcam.js
// Usage: openWebcamModal({ fileInputId: 'profilePicture', previewSelector: '.profile-preview' })

(function(window) {
    let stream = null;
    let webcamModal = null;
    let capturedBlob = null;
    let fileInputId = null;
    let previewSelector = null;

    function startWebcam() {
        return navigator.mediaDevices.getUserMedia({
            video: {
                width: { ideal: 640 },
                height: { ideal: 480 },
                facingMode: 'user'
            }
        }).then(function(mediaStream) {
            stream = mediaStream;
            const video = document.getElementById('webcamVideo');
            video.srcObject = stream;
            $('#captureBtn').show();
            $('#retakeBtn').hide();
            $('#usePhotoBtn').hide();
            $('#webcamPreview').hide();
            $('#webcamVideo').show();
        }).catch(function(error) {
            alert('Unable to access webcam. Please make sure you have granted camera permissions and try again.');
        });
    }

    function stopWebcam() {
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
            stream = null;
        }
    }

    function setupHandlers() {
        $('#captureBtn').off('click').on('click', function() {
            const video = document.getElementById('webcamVideo');
            const canvas = document.getElementById('webcamCanvas');
            const capturedImage = document.getElementById('capturedImage');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            const ctx = canvas.getContext('2d');
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
            canvas.toBlob(function(blob) {
                if (blob) {
                    capturedBlob = blob;
                    const imageUrl = URL.createObjectURL(blob);
                    capturedImage.src = imageUrl;
                    $('#webcamVideo').hide();
                    $('#captureBtn').hide();
                    $('#webcamPreview').show();
                    $('#retakeBtn').show();
                    $('#usePhotoBtn').show();
                } else {
                    alert('Failed to capture photo. Please try again.');
                }
            }, 'image/jpeg', 0.8);
        });
        $('#retakeBtn').off('click').on('click', function() {
            capturedBlob = null;
            $('#webcamVideo').show();
            $('#captureBtn').show();
            $('#webcamPreview').hide();
            $('#retakeBtn').hide();
            $('#usePhotoBtn').hide();
        });
        $('#usePhotoBtn').off('click').on('click', function() {
            if (capturedBlob) {
                // Convert blob to File object
                const capturedFile = new File([capturedBlob], 'webcam-capture.jpg', {
                    type: 'image/jpeg',
                    lastModified: Date.now()
                });
                // Update the file input
                const dataTransfer = new DataTransfer();
                dataTransfer.items.add(capturedFile);
                document.getElementById(fileInputId).files = dataTransfer.files;
                // Create preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.querySelector(previewSelector);
                    if (preview) {
                        preview.innerHTML = '';
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.alt = 'Preview';
                        img.style.maxWidth = '100%';
                        img.style.height = 'auto';
                        img.style.borderRadius = '8px';
                        preview.appendChild(img);
                    }
                };
                reader.readAsDataURL(capturedFile);
                // Hide modal and stop webcam
                $(webcamModal).modal('hide');
                stopWebcam();
            } else {
                alert('No captured image data found. Please capture a photo first.');
            }
        });
        $('#webcamModal').off('hidden.bs.modal').on('hidden.bs.modal', function() {
            stopWebcam();
            // Reset modal state for next use
            $('#webcamVideo').show();
            $('#captureBtn').show();
            $('#webcamPreview').hide();
            $('#retakeBtn').hide();
            $('#usePhotoBtn').hide();
        });
        $(window).off('beforeunload.webcam').on('beforeunload.webcam', function() {
            stopWebcam();
        });
    }

    window.openWebcamModal = function(opts) {
        fileInputId = opts.fileInputId;
        previewSelector = opts.previewSelector;
        webcamModal = document.getElementById('webcamModal');
        startWebcam().then(function() {
            setupHandlers();
            $(webcamModal).modal('show');
        });
    };
})(window); 