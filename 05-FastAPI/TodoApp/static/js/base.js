    // Simple UI Functions
    function showLoading(button) {
        const originalText = button.innerHTML;
        button.innerHTML = 'Processing...';
        button.disabled = true;
        return originalText;
    }

    function hideLoading(button, originalText) {
        button.innerHTML = originalText;
        button.disabled = false;
    }

    // Add Todo JS
    const todoForm = document.getElementById('todoForm');
    if (todoForm) {
        todoForm.addEventListener('submit', async function (event) {
            event.preventDefault();

            const form = event.target;
            const submitButton = form.querySelector('button[type="submit"]');
            const originalText = showLoading(submitButton);

            const formData = new FormData(form);
            const data = Object.fromEntries(formData.entries());

            const payload = {
                title: data.title,
                description: data.description,
                priority: parseInt(data.priority),
                complete: false
            };

            try {
                const response = await fetch('/todos/todo', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${getCookie('access_token')}`
                    },
                    body: JSON.stringify(payload)
                });

                if (response.ok) {
                    window.location.href = '/todos/todo-page';
                } else {
                    const errorData = await response.json();
                    alert(`Error: ${errorData.detail}`);
                }
            } catch (error) {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            } finally {
                hideLoading(submitButton, originalText);
            }
        });
    }

    // Edit Todo JS
    const editTodoForm = document.getElementById('editTodoForm');
    if (editTodoForm) {
        editTodoForm.addEventListener('submit', async function (event) {
            event.preventDefault();

            const form = event.target;
            const submitButton = form.querySelector('button[type="submit"]');
            const originalText = showLoading(submitButton);

            const formData = new FormData(form);
            const data = Object.fromEntries(formData.entries());
            var url = window.location.pathname;
            const todoId = url.substring(url.lastIndexOf('/') + 1);

            const payload = {
                title: data.title,
                description: data.description,
                priority: parseInt(data.priority),
                complete: data.complete === "on"
            };

            try {
                const token = getCookie('access_token');
                if (!token) {
                    throw new Error('Authentication token not found');
                }

                const response = await fetch(`/todos/todo/${todoId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify(payload)
                });

                if (response.ok) {
                    window.location.href = '/todos/todo-page';
                } else {
                    const errorData = await response.json();
                    alert(`Error: ${errorData.detail}`);
                }
            } catch (error) {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            } finally {
                hideLoading(submitButton, originalText);
            }
        });

        // Enhanced Delete Button
        const deleteButton = document.getElementById('deleteButton');
        if (deleteButton) {
            deleteButton.addEventListener('click', async function () {
                if (!confirm('⚠️ Are you sure you want to delete this task? This action cannot be undone.')) {
                    return;
                }

                const originalText = showLoading(this);
                var url = window.location.pathname;
                const todoId = url.substring(url.lastIndexOf('/') + 1);

                try {
                    const token = getCookie('access_token');
                    if (!token) {
                        throw new Error('Authentication token not found');
                    }

                    const response = await fetch(`/todos/todo/${todoId}`, {
                        method: 'DELETE',
                        headers: {
                            'Authorization': `Bearer ${token}`
                        }
                    });

                    if (response.ok) {
                        window.location.href = '/todos/todo-page';
                    } else {
                        const errorData = await response.json();
                        alert(`Error: ${errorData.detail}`);
                    }
                } catch (error) {
                    console.error('Error:', error);
                    alert('An error occurred. Please try again.');
                } finally {
                    hideLoading(this, originalText);
                }
            });
        }
    }

    // Enhanced Login JS
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', async function (event) {
            event.preventDefault();

            const form = event.target;
            const submitButton = form.querySelector('button[type="submit"]');
            const originalText = showLoading(submitButton);

            const formData = new FormData(form);

            const payload = new URLSearchParams();
            for (const [key, value] of formData.entries()) {
                payload.append(key, value);
            }

            try {
                const response = await fetch('/auth/token', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: payload.toString()
                });

                if (response.ok) {
                    const data = await response.json();
                    // Delete any existing cookies
                    logout();
                    // Save token to cookie
                    document.cookie = `access_token=${data.access_token}; path=/`;
                    window.location.href = '/todos/todo-page';
                } else {
                    const errorData = await response.json();
                    alert(`Login failed: ${errorData.detail}`);
                }
            } catch (error) {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            } finally {
                hideLoading(submitButton, originalText);
            }
        });
    }

    // Enhanced Register JS
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        // Real-time password validation
        const password = registerForm.querySelector('input[name="password"]');
        const password2 = registerForm.querySelector('input[name="password2"]');

        if (password2) {
            password2.addEventListener('input', function() {
                if (password.value !== password2.value) {
                    password2.setCustomValidity('Passwords do not match');
                    password2.classList.add('is-invalid');
                } else {
                    password2.setCustomValidity('');
                    password2.classList.remove('is-invalid');
                    password2.classList.add('is-valid');
                }
            });
        }

        registerForm.addEventListener('submit', async function (event) {
            event.preventDefault();

            const form = event.target;
            const submitButton = form.querySelector('button[type="submit"]');
            const originalText = showLoading(submitButton);

            const formData = new FormData(form);
            const data = Object.fromEntries(formData.entries());

            if (data.password !== data.password2) {
                alert('Passwords do not match');
                hideLoading(submitButton, originalText);
                return;
            }

            const payload = {
                email: data.email,
                username: data.username,
                first_name: data.firstname,
                last_name: data.lastname,
                role: data.role,
                phone_number: data.phone_number,
                password: data.password
            };

            try {
                const response = await fetch('/auth', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });

                if (response.ok) {
                    alert('Account created successfully! Redirecting to login...');
                    window.location.href = '/auth/login-page';
                } else {
                    const errorData = await response.json();
                    alert(`Registration failed: ${errorData.detail || errorData.message}`);
                }
            } catch (error) {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            } finally {
                hideLoading(submitButton, originalText);
            }
        });
    }





    // Helper function to get a cookie by name
    function getCookie(name) {
        let cookieValue = null;
        if (document.cookie && document.cookie !== '') {
            const cookies = document.cookie.split(';');
            for (let i = 0; i < cookies.length; i++) {
                const cookie = cookies[i].trim();
                if (cookie.substring(0, name.length + 1) === (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    };

    function logout() {
        // Get all cookies
        const cookies = document.cookie.split(";");

        // Iterate through all cookies and delete each one
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i];
            const eqPos = cookie.indexOf("=");
            const name = eqPos > -1 ? cookie.substr(0, eqPos).trim() : cookie.trim();
            // Delete cookie for current path and root path
            document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/";
            document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/auth/";
            document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/todos/";
        }

        // Clear any local storage
        localStorage.clear();
        sessionStorage.clear();

        // Redirect to login page
        window.location.href = '/auth/login-page';
    };
