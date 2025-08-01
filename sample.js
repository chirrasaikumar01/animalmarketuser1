// Sample JavaScript File
// This file contains various JavaScript examples and utilities

// ========================================
// Basic Functions
// ========================================

/**
 * Greets a user with a personalized message
 * @param {string} name - The name of the person to greet
 * @param {string} timeOfDay - The time of day (morning, afternoon, evening)
 * @returns {string} A personalized greeting message
 */
function greetUser(name, timeOfDay = 'day') {
    const greetings = {
        morning: 'Good morning',
        afternoon: 'Good afternoon', 
        evening: 'Good evening',
        day: 'Hello'
    };
    
    return `${greetings[timeOfDay] || greetings.day}, ${name}! Welcome to our application.`;
}

/**
 * Calculates the sum of an array of numbers
 * @param {number[]} numbers - Array of numbers to sum
 * @returns {number} The sum of all numbers
 */
function calculateSum(numbers) {
    return numbers.reduce((sum, num) => sum + num, 0);
}

/**
 * Formats a date in a readable format
 * @param {Date} date - The date to format
 * @returns {string} Formatted date string
 */
function formatDate(date) {
    const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
        weekday: 'long'
    };
    return date.toLocaleDateString('en-US', options);
}

// ========================================
// DOM Manipulation Examples
// ========================================

/**
 * Creates a new element and adds it to the page
 * @param {string} tagName - The HTML tag name
 * @param {string} text - The text content
 * @param {string} className - CSS class name
 * @returns {HTMLElement} The created element
 */
function createElement(tagName, text, className = '') {
    const element = document.createElement(tagName);
    element.textContent = text;
    if (className) {
        element.className = className;
    }
    return element;
}

/**
 * Adds a new item to a list
 * @param {string} itemText - The text for the new list item
 * @param {string} listId - The ID of the list element
 */
function addListItem(itemText, listId) {
    const list = document.getElementById(listId);
    if (list) {
        const listItem = createElement('li', itemText, 'list-item');
        list.appendChild(listItem);
    }
}

// ========================================
// Event Handlers
// ========================================

/**
 * Handles form submission
 * @param {Event} event - The form submission event
 */
function handleFormSubmit(event) {
    event.preventDefault();
    
    const formData = new FormData(event.target);
    const data = Object.fromEntries(formData);
    
    console.log('Form submitted with data:', data);
    
    // You can add your form processing logic here
    alert('Form submitted successfully!');
}

/**
 * Handles button click events
 * @param {string} action - The action to perform
 */
function handleButtonClick(action) {
    switch(action) {
        case 'greet':
            const name = prompt('Enter your name:');
            if (name) {
                alert(greetUser(name));
            }
            break;
        case 'calculate':
            const numbers = prompt('Enter numbers separated by commas:');
            if (numbers) {
                const numArray = numbers.split(',').map(n => parseFloat(n.trim()));
                const sum = calculateSum(numArray);
                alert(`Sum: ${sum}`);
            }
            break;
        case 'date':
            alert(`Today is: ${formatDate(new Date())}`);
            break;
        default:
            console.log('Unknown action:', action);
    }
}

// ========================================
// Utility Functions
// ========================================

/**
 * Debounces a function call
 * @param {Function} func - The function to debounce
 * @param {number} delay - The delay in milliseconds
 * @returns {Function} The debounced function
 */
function debounce(func, delay) {
    let timeoutId;
    return function (...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
}

/**
 * Generates a random color in hex format
 * @returns {string} A random hex color
 */
function getRandomColor() {
    return '#' + Math.floor(Math.random() * 16777215).toString(16);
}

/**
 * Validates an email address
 * @param {string} email - The email to validate
 * @returns {boolean} True if email is valid
 */
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// ========================================
// Example Usage and Initialization
// ========================================

// Example usage of the functions
console.log('Sample JavaScript file loaded!');

// Example: Greet user
console.log(greetUser('John', 'morning'));

// Example: Calculate sum
console.log('Sum of [1, 2, 3, 4, 5]:', calculateSum([1, 2, 3, 4, 5]));

// Example: Format date
console.log('Today:', formatDate(new Date()));

// Example: Generate random color
console.log('Random color:', getRandomColor());

// Example: Validate email
console.log('Email validation:', isValidEmail('test@example.com'));

// Export functions for use in other modules (if using modules)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        greetUser,
        calculateSum,
        formatDate,
        createElement,
        addListItem,
        handleFormSubmit,
        handleButtonClick,
        debounce,
        getRandomColor,
        isValidEmail
    };
} 