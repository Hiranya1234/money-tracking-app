document.addEventListener('DOMContentLoaded', function () {
    // Navigation function to show the appropriate section
    function navigateTo(sectionId) {
        const sections = document.querySelectorAll('main > section');
        sections.forEach(section => {
            section.classList.add('hidden');
        });
        document.getElementById(sectionId).classList.remove('hidden');

        if (sectionId === 'loggedInUsers') {
            fetchLoggedInUsers();
        }
    }

    // Function to fetch and display logged-in users from Firebase
    /*function fetchLoggedInUsers() {
        const dbRef = firebase.database().ref('loggedInUsers'); // Adjust the reference path as per your database structure
        dbRef.once('value', (snapshot) => {
            const data = snapshot.val();
            const tbody = document.getElementById('loggedInUserTableBody');
            tbody.innerHTML = ''; // Clear existing rows

            for (let key in data) {
                if (data.hasOwnProperty(key)) {
                    const user = data[key];
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${user.userName}</td>
                        <td>${user.fullName}</td>
                        <td>${user.email}</td>
                        <td>${user.age}</td>
                    `;
                    tbody.appendChild(row);
                }
            }
        }).catch(error => {
            console.error('Error fetching logged-in users:', error);
        });
    }*/

    // Attach the navigateTo function to all links with onclick attribute
    const navLinks = document.querySelectorAll('nav a');
    navLinks.forEach(link => {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            const sectionId = this.getAttribute('onclick').match(/'(.*?)'/)[1];
            navigateTo(sectionId);
        });
    });

    // Example initial navigation
    navigateTo('dashboard');
});

