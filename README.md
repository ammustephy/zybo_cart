# zybo_cart

## Overview

This Flutter application is an e-commerce platform built using the BLoC (Business Logic Component) pattern for state management. It features a seamless user journey from authentication to product browsing, with a focus on a clean, responsive UI and robust API integration. The app includes a splash screen, user authentication (login and OTP verification), user profile setup, a home screen with product browsing, a wishlist, and a user profile page. The UI strictly adheres to the provided design specifications, ensuring pixel-perfect implementation.
The app integrates with provided APIs for authentication, user data, product search, product listing, banners, wishlist management, and user profile fetching. It uses MediaQuery for responsive design to prevent overflow/overlap issues across different screen sizes.

## Features

1. Splash Screen
Displays a centered image for a brief duration before navigating to the Login page.
Ensures a smooth onboarding experience.

Screenshot: ![Splash](https://github.com/user-attachments/assets/408a0c51-ce5c-4a1f-97c9-6cbaa0e63a09)

2. Login Page
UI: Features a "Login" heading, a subheading, a phone number input field with country code (default: +91), and a "Continue" button.
Functionality:
* Users enter their phone number, which is sent to the POST /api/verify/ API.
* Request: {"phone_number": "+917907761417"}
* Response: Includes OTP, access token, and user existence status.
* On successful response, navigates to the OTP Verification page.
* Error Handling: Displays error messages for invalid inputs or API failures.

Screenshot: ![Login](https://github.com/user-attachments/assets/a05b64dd-a83a-4ce2-8b9c-90cf89ecf09a)
![Login with Num](https://github.com/user-attachments/assets/78517eb7-2d50-4edd-ba7b-52c970c776d9)

3. OTP Verification Page
UI: Displays:
Heading: "OTP VERIFICATION"
Subheading: "Enter the OTP sent to {phone_number}" (fetched from Login page input).
Text: "OTP is {otp}" (from API response).
Four input boxes for OTP entry.
A countdown timer for OTP expiration.
A "Re-send" link to resend the OTP (calls POST /api/verify/ again).
A "Submit" button.
A back button (arrow in a box) to return to the Login page.
Functionality:
* Validates the entered OTP against the API response.
* On successful verification, navigates to the Name Entry page if the user is new, or to the Home page if the user exists.
* Error Handling: Shows errors for incorrect OTP or API issues.

Screenshot: ![Otp verification](https://github.com/user-attachments/assets/5952c1fd-1bb0-4235-8d79-9e15335e7853)

4. Name Entry Page
UI: Contains:
A text field for entering the user's first name.
A "Submit" button.
A back button (arrow in a box) to return to the OTP Verification page.
Functionality:
* Submits the phone number and first name to POST /api/login-register/ with the stored token in the header.
* Request: {"phone_number": "+917907761417", "first_name": "Ammu"}
* Response: Includes new access token, user ID, and success message.
* On success, navigates to the Home page.
* Error Handling: Displays errors for invalid inputs or API failures.

Screenshot: ![Name](https://github.com/user-attachments/assets/3533fb67-ab22-4cf6-9f87-e32d2f644c99)

5. Home Page
UI: Includes:
A search bar with a search icon, filtering products by query (e.g., "herb").
A carousel slider displaying banners fetched from GET /api/banners/.
A "Popular Products" heading.
A grid view of products fetched from GET /api/products/, showing:
Product image (featured_image).
Name.
Striked price (MRP).
Actual price (sale_price).
Rating with star icons (avg_rating).
Wishlist icon (toggles add/remove wishlist).
A bottom navigation bar with Home, Wishlist, and Profile tabs.
Functionality:
* Search: Calls POST /api/search/?query={query} to filter products.
* Banners: Fetches and displays banners with images.
* Products: Displays products in a grid, with wishlist toggle functionality using POST /api/add-remove-wishlist/.
* Navigation: Switches between Home, Wishlist, and Profile pages.
* Error Handling: Handles API errors and displays placeholders for failed loads.

Screenshot: ![Home-1](https://github.com/user-attachments/assets/425bc549-9424-4df4-aad2-267cab074947)
![Home-2](https://github.com/user-attachments/assets/cee6d1ba-fb86-4504-8a5e-33fd274780c4)

6. Wishlist Page
UI: Displays a list of wishlisted products fetched from GET /api/wishlist/, showing:
Product image, name, striked price, actual price, rating, and wishlist icon.
Functionality:
* Fetches wishlist items using the stored token.
* Allows adding/removing products via POST /api/add-remove-wishlist/ by passing the product ID.
* Error Handling: Shows an empty state or error message if the wishlist is empty or the API fails.

Screenshot: ![Wishlist-1](https://github.com/user-attachments/assets/c25fb716-9d7d-4335-b7a2-67194ddc9c6c)
![Wishlist-3](https://github.com/user-attachments/assets/ef4e0c12-851f-4e52-a80a-6d7c707bd7ba)
![Wishlist-Empty](https://github.com/user-attachments/assets/0032e9bc-aa31-4f9b-88f8-926ddd63a929)

7. Profile Page
UI: Displays:
User's name and phone number fetched from GET /user-data/.
Functionality:
* Fetches user data using the stored token in the header.
* Error Handling: Displays an error message if the API call fails.

Screenshot: ![Profile](https://github.com/user-attachments/assets/cb02ff7b-8037-4a83-923a-067b548ceca5)


