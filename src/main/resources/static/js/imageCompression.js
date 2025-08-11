/**
 * Image compression utility functions
 */

const ImageCompression = {
    /**
     * Compresses an image file to a specified maximum size while maintaining aspect ratio
     * @param {File} file - The image file to compress
     * @param {Object} options - Compression options
     * @param {number} options.maxSizeKB - Maximum file size in KB (default: 150)
     * @param {number} options.maxDimension - Maximum width/height in pixels (default: 800)
     * @param {number} options.quality - Initial JPEG quality (default: 0.9)
     * @returns {Promise<File>} - Compressed image file
     */
    async compressImage(file, options = {}) {
        const {
            maxSizeKB = 100, // Reduced from 150KB to 100KB for faster loading
            maxDimension = 1200, // Increased from 800 to 1200 for better quality
            quality = 0.85 // Reduced from 0.9 to 0.85 for better compression
        } = options;

        return new Promise((resolve) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = function(event) {
                const img = new Image();
                img.src = event.target.result;
                img.onload = function() {
                    const canvas = document.createElement('canvas');
                    let width = img.width;
                    let height = img.height;
                    
                    // Calculate new dimensions while maintaining aspect ratio
                    if (width > height && width > maxDimension) {
                        height = Math.round((height * maxDimension) / width);
                        width = maxDimension;
                    } else if (height > maxDimension) {
                        width = Math.round((width * maxDimension) / height);
                        height = maxDimension;
                    }
                    
                    canvas.width = width;
                    canvas.height = height;
                    
                    const ctx = canvas.getContext('2d');
                    ctx.drawImage(img, 0, 0, width, height);
                    
                    // Start with specified quality
                    let currentQuality = quality;
                    let compressedDataUrl = canvas.toDataURL('image/jpeg', currentQuality);
                    
                    // Reduce quality until file size is under maxSizeKB
                    while (compressedDataUrl.length > maxSizeKB * 1024 && currentQuality > 0.1) {
                        currentQuality -= 0.1;
                        compressedDataUrl = canvas.toDataURL('image/jpeg', currentQuality);
                    }
                    
                    // Convert base64 to blob
                    fetch(compressedDataUrl)
                        .then(res => res.blob())
                        .then(blob => {
                            // Create a new file from the blob
                            const compressedFile = new File([blob], file.name, {
                                type: 'image/jpeg',
                                lastModified: Date.now()
                            });
                            resolve(compressedFile);
                        });
                };
            };
        });
    },

    /**
     * Updates a file input with a compressed image
     * @param {HTMLInputElement} fileInput - The file input element
     * @param {File} compressedFile - The compressed file
     */
    updateFileInput(fileInput, compressedFile) {
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(compressedFile);
        fileInput.files = dataTransfer.files;
    },

    /**
     * Creates a preview of an image
     * @param {File} file - The image file
     * @param {HTMLElement} previewElement - The element to show the preview in
     * @param {Object} options - Preview options
     * @param {string} options.defaultIcon - Default icon HTML when no image (default: user circle icon)
     * @param {string} options.defaultText - Default text when no image (default: "No image selected")
     */
    createPreview(file, previewElement, options = {}) {
        const {
            defaultIcon = '<i class="fas fa-user-circle"></i>',
            defaultText = 'No image selected'
        } = options;

        if (!file) {
            previewElement.innerHTML = `${defaultIcon}<span>${defaultText}</span>`;
            return;
        }

        const reader = new FileReader();
        reader.onload = function(e) {
            previewElement.innerHTML = '';
            const img = document.createElement('img');
            img.src = e.target.result;
            img.alt = 'Preview';
            previewElement.appendChild(img);
        };
        reader.readAsDataURL(file);
    },

    /**
     * Shows a loading state in the preview element
     * @param {HTMLElement} previewElement - The element to show loading state in
     * @param {string} loadingText - Text to show while loading (default: "Compressing image...")
     */
    showLoading(previewElement, loadingText = 'Compressing image...') {
        previewElement.innerHTML = `<i class="fas fa-spinner fa-spin"></i><span>${loadingText}</span>`;
    }
}; 