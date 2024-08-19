document.addEventListener('DOMContentLoaded', function() {
    const tabButtons = document.querySelectorAll('.tab-button');
    const tabContents = {
        "new-england": document.getElementById('new-england-gallery'),
        "iceland": document.getElementById('iceland-gallery'),
        "boston": document.getElementById('boston-gallery'),
        "about-me": document.getElementById('about-me')
    };
    let currentImages = [];
    let currentImageIndex = 0;

    // Show the first tab (New England) by default
    tabContents["new-england"].style.display = 'block';
    document.querySelector('[data-tab="new-england"]').classList.add('active');
    updateCurrentImages('new-england');

    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Remove active class from all buttons
            tabButtons.forEach(btn => btn.classList.remove('active'));

            // Add active class to the clicked button
            button.classList.add('active');

            // Hide all tab contents
            for (let key in tabContents) {
                tabContents[key].style.display = 'none';
            }

            // Show the clicked tab's content
            const tab = button.getAttribute('data-tab');
            tabContents[tab].style.display = 'block';
            updateCurrentImages(tab);
        });
    });

    // Function to update the current images based on the selected tab
    function updateCurrentImages(tab) {
        currentImages = Array.from(document.querySelectorAll(`#${tab}-gallery .image-container img`));
        currentImageIndex = 0; // Reset index when switching tabs

        // Rebind click events for fullscreen functionality
        currentImages.forEach((img, index) => {
            img.removeEventListener('click', handleImageClick);
            img.addEventListener('click', () => handleImageClick(index));
        });
    }

    // Full-screen image functionality
    const fullScreenView = document.getElementById('full-screen-view');
    const fullImage = document.getElementById('full-image');

    function showImage(index) {
        fullImage.src = currentImages[index].src;
        // Disable or enable navigation buttons based on the index
        document.getElementById('prev-btn').style.visibility = index === 0 ? 'hidden' : 'visible';
        document.getElementById('next-btn').style.visibility = index === currentImages.length - 1 ? 'hidden' : 'visible';
    }

    function handleImageClick(index) {
        currentImageIndex = index;
        showImage(currentImageIndex);
        fullScreenView.style.display = 'flex';
    }

    document.getElementById('close-btn').addEventListener('click', () => {
        fullScreenView.style.display = 'none';
    });

    document.getElementById('prev-btn').addEventListener('click', () => {
        if (currentImageIndex > 0) {
            currentImageIndex--;
            showImage(currentImageIndex);
        }
    });

    document.getElementById('next-btn').addEventListener('click', () => {
        if (currentImageIndex < currentImages.length - 1) {
            currentImageIndex++;
            showImage(currentImageIndex);
        }
    });

    // Close full-screen view when clicking outside the image
    fullScreenView.addEventListener('click', (event) => {
        if (event.target === fullScreenView) {
            fullScreenView.style.display = 'none';
        }
    });

    // Handle keyboard navigation for left/right arrow keys and escape key
    document.addEventListener('keydown', function(event) {
        if (fullScreenView.style.display === 'flex') {
            if (event.key === 'ArrowRight' && currentImageIndex < currentImages.length - 1) {
                currentImageIndex++;
                showImage(currentImageIndex);
            } else if (event.key === 'ArrowLeft' && currentImageIndex > 0) {
                currentImageIndex--;
                showImage(currentImageIndex);
            } else if (event.key === 'Escape') {
                fullScreenView.style.display = 'none';
            }
        }
    });

    // Initialize the first tab's images
    updateCurrentImages('new-england');
});
