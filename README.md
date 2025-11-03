<div id="top">

<!-- HEADER STYLE: CLASSIC -->
<div align="center">

<img src=".github/assets/logo/logo-primary.png" width="30%" style="position: relative; top: 0; right: 0;" alt="Project Logo"/>

# <code>EasyEat</code>

<em></em>

<!-- BADGES -->
<!-- local repository, no metadata badges. -->

<em>Built with the tools and technologies:</em>

<img src="https://img.shields.io/badge/JSON-000000.svg?style=default&logo=JSON&logoColor=white" alt="JSON">
<img src="https://img.shields.io/badge/npm-CB3837.svg?style=default&logo=npm&logoColor=white" alt="npm">
<img src="https://img.shields.io/badge/Prettier-F7B93E.svg?style=default&logo=Prettier&logoColor=black" alt="Prettier">
<img src="https://img.shields.io/badge/JavaScript-F7DF1E.svg?style=default&logo=JavaScript&logoColor=black" alt="JavaScript">
<img src="https://img.shields.io/badge/Vue.js-4FC08D.svg?style=default&logo=vuedotjs&logoColor=white" alt="Vue.js">
<img src="https://img.shields.io/badge/Org-77AA99.svg?style=default&logo=Org&logoColor=white" alt="Org">
<img src="https://img.shields.io/badge/Gradle-02303A.svg?style=default&logo=Gradle&logoColor=white" alt="Gradle">
<br>
<img src="https://img.shields.io/badge/PostgreSQL-4169E1.svg?style=default&logo=PostgreSQL&logoColor=white" alt="PostgreSQL">
<img src="https://img.shields.io/badge/Vite-646CFF.svg?style=default&logo=Vite&logoColor=white" alt="Vite">
<img src="https://img.shields.io/badge/bat-31369E.svg?style=default&logo=bat&logoColor=white" alt="bat">
<img src="https://img.shields.io/badge/Kotlin-7F52FF.svg?style=default&logo=Kotlin&logoColor=white" alt="Kotlin">
<img src="https://img.shields.io/badge/Axios-5A29E4.svg?style=default&logo=Axios&logoColor=white" alt="Axios">
<img src="https://img.shields.io/badge/Bootstrap-7952B3.svg?style=default&logo=Bootstrap&logoColor=white" alt="Bootstrap">
<img src="https://img.shields.io/badge/Sass-CC6699.svg?style=default&logo=Sass&logoColor=white" alt="Sass">

</div>
<br>

---

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
    - [Project Index](#project-index)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Usage](#usage)
    - [Testing](#testing)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Overview

- Built with Spring Boot, JPA/Hibernate, PostgreSQL, and Vue.

- Traditional food vendors often rely on walk-in customers, which is increasingly inconvenient as traffic grows and vendors are spread across the city. Many people simply don’t have the time or ability to travel to each location.

- EasyEat solves this by providing a food-delivery–focused e-commerce platform that connects local vendors to nearby customers. Users can browse menus, place orders, and receive food without navigating traffic or searching for vendors themselves.

- This makes local food more accessible, while helping vendors reach more customers with minimal effort.

### This project is designed as a learning and demonstration platform to practice:

- Backend API design and structure  
- Secure authentication & session handling  
- Efficient database access in a relational system  
- Clean separation of concerns in a layered architecture  
- Collaboration readiness through conventions and documentation  

---

## Features

- Homepage displays top selling products, new arrivals, and products by category
- Search allows the user to search by keywords, then sort by category or price, in both asc & desc orders
- Vendor(Seller) accounts can be applied for and accepted by Admins
- User auth: Login, Logout, Register
- User can edit their own account information
- User can change their passwords, or reset passwords when lost
- Vendors(Sellers) can soft delete their products via an isActive toggle
- User can view the product's details, select from variations and add it to cart
- User can edit the product's amount, or delete item from cart

### Technical Highlights

- Secure authentication system with BCrypt password hashing and SHA-256 session tokens  
- Role-based authorization to restrict protected endpoints  
- Optimized database access to avoid N+1 query problems  
- Lazy loading by default, with targeted `@EntityGraph` and fetch joins to prevent N+1 when mapping collections to DTOs.
- Clean layered architecture (Entity → DTO → Mapper → Repository → Service → Controller)  
- Centralized exception handling and validation using Jakarta Validation  
- Consistent API error/response format  
- Inline controller documentation via Javadoc  
- Development CORS support for local Vue frontend integration  

---

## Project Structure

```sh
└── /
    ├── .github
    │   └── CODEOWNERS
    ├── backend
    │   ├── .gitignore
    │   ├── .idea
    │   ├── build.gradle.kts
    │   ├── database
    │   ├── gradle
    │   ├── gradlew
    │   ├── gradlew.bat
    │   ├── settings.gradle.kts
    │   └── src
    ├── frontend
    │   ├── .env.development
    │   ├── .env.production
    │   ├── .gitattributes
    │   ├── .gitignore
    │   ├── .prettierrc.json
    │   ├── .vscode
    │   ├── index.html
    │   ├── jsconfig.json
    │   ├── package-lock.json
    │   ├── package.json
    │   ├── public
    │   ├── src
    │   └── vite.config.js
    └── README.md
```

### Project Index

<details open>
	<summary><b><code>/</code></b></summary>
	<!-- .github Submodule -->
	<details>
		<summary><b>.github</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ .github</b></code>
			<table style='width: 100%; border-collapse: collapse;'>
			<thead>
				<tr style='background-color: #f8f9fa;'>
					<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
					<th style='text-align: left; padding: 8px;'>Summary</th>
				</tr>
			</thead>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/.github/CODEOWNERS'>CODEOWNERS</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
			</table>
		</blockquote>
	</details>
	<!-- backend Submodule -->
	<details>
		<summary><b>backend</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ backend</b></code>
			<table style='width: 100%; border-collapse: collapse;'>
			<thead>
				<tr style='background-color: #f8f9fa;'>
					<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
					<th style='text-align: left; padding: 8px;'>Summary</th>
				</tr>
			</thead>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/backend/build.gradle.kts'>build.gradle.kts</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/backend/gradlew.bat'>gradlew.bat</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/backend/settings.gradle.kts'>settings.gradle.kts</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
			</table>
			<!-- database Submodule -->
			<details>
				<summary><b>database</b></summary>
				<blockquote>
					<div class='directory-path' style='padding: 8px 0; color: #666;'>
						<code><b>⦿ backend.database</b></code>
					<table style='width: 100%; border-collapse: collapse;'>
					<thead>
						<tr style='background-color: #f8f9fa;'>
							<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
							<th style='text-align: left; padding: 8px;'>Summary</th>
						</tr>
					</thead>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='/backend/database/Mock_data.sql'>Mock_data.sql</a></b></td>
							<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
						</tr>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='/backend/database/Schema.sql'>Schema.sql</a></b></td>
							<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
						</tr>
					</table>
				</blockquote>
			</details>
			<!-- src Submodule -->
			<details>
				<summary><b>src</b></summary>
				<blockquote>
					<div class='directory-path' style='padding: 8px 0; color: #666;'>
						<code><b>⦿ backend.src</b></code>
					<!-- main Submodule -->
					<details>
						<summary><b>main</b></summary>
						<blockquote>
							<div class='directory-path' style='padding: 8px 0; color: #666;'>
								<code><b>⦿ backend.src.main</b></code>
							<!-- resources Submodule -->
							<details>
								<summary><b>resources</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ backend.src.main.resources</b></code>
									<table style='width: 100%; border-collapse: collapse;'>
									<thead>
										<tr style='background-color: #f8f9fa;'>
											<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
											<th style='text-align: left; padding: 8px;'>Summary</th>
										</tr>
									</thead>
										<tr style='border-bottom: 1px solid #eee;'>
											<td style='padding: 8px;'><b><a href='/backend/src/main/resources/application.properties.example'>application.properties.example</a></b></td>
											<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
										</tr>
									</table>
								</blockquote>
							</details>
							<!-- java Submodule -->
							<details>
								<summary><b>java</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ backend.src.main.java</b></code>
									<!-- com Submodule -->
									<details>
										<summary><b>com</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ backend.src.main.java.com</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/Application.java'>Application.java</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
											<!-- advice Submodule -->
											<details>
												<summary><b>advice</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.advice</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/advice/AuthExceptionHandler.java'>AuthExceptionHandler.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/advice/ValidationExceptionHandler.java'>ValidationExceptionHandler.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- configuration Submodule -->
											<details>
												<summary><b>configuration</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.configuration</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/configuration/CorsConfig.java'>CorsConfig.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- controller Submodule -->
											<details>
												<summary><b>controller</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.controller</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/controller/AuthController.java'>AuthController.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/controller/CartController.java'>CartController.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/controller/CategoryController.java'>CategoryController.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/controller/ProductController.java'>ProductController.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/controller/SellerController.java'>SellerController.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/controller/UserController.java'>UserController.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- entity Submodule -->
											<details>
												<summary><b>entity</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.entity</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Address.java'>Address.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Admin.java'>Admin.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Cart.java'>Cart.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Category.java'>Category.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/City.java'>City.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Customer.java'>Customer.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Product.java'>Product.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Role.java'>Role.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Seller.java'>Seller.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Session.java'>Session.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/User.java'>User.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/Variation.java'>Variation.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/entity/VerificationToken.java'>VerificationToken.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- exception Submodule -->
											<details>
												<summary><b>exception</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.exception</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/CartItemNotFoundException.java'>CartItemNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/CartNotFoundException.java'>CartNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/CategoryDeletionException.java'>CategoryDeletionException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/CategoryNotFoundException.java'>CategoryNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/InvalidLoginException.java'>InvalidLoginException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/ProductNotFoundException.java'>ProductNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/RoleNotFoundException.java'>RoleNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/SellerNotFoundException.java'>SellerNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/SessionNotFoundException.java'>SessionNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/SessionTokenNotFoundException.java'>SessionTokenNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/UserAlreadyExistException.java'>UserAlreadyExistException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/UserNotFoundException.java'>UserNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/exception/VariationNotFoundException.java'>VariationNotFoundException.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- mapper Submodule -->
											<details>
												<summary><b>mapper</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.mapper</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/AddressMapper.java'>AddressMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/AdminMapper.java'>AdminMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/CartMapper.java'>CartMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/CategoryMapper.java'>CategoryMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/CityMapper.java'>CityMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/CustomerMapper.java'>CustomerMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/ProductMapper.java'>ProductMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/RoleMapper.java'>RoleMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/SellerMapper.java'>SellerMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/SessionMapper.java'>SessionMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/UserMapper.java'>UserMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/VariationMapper.java'>VariationMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/mapper/VerificationTokenMapper.java'>VerificationTokenMapper.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- repository Submodule -->
											<details>
												<summary><b>repository</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.repository</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/AddressRepository.java'>AddressRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/AdminRepository.java'>AdminRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/CartRepository.java'>CartRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/CategoryRepository.java'>CategoryRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/CityRepository.java'>CityRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/CustomerRepository.java'>CustomerRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/ProductRepository.java'>ProductRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/RoleRepository.java'>RoleRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/SellerRepository.java'>SellerRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/SessionRepository.java'>SessionRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/UserRepository.java'>UserRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/VariationRepository.java'>VariationRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/repository/VerificationTokenRepository.java'>VerificationTokenRepository.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- service Submodule -->
											<details>
												<summary><b>service</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.service</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/CartService.java'>CartService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/CategoryService.java'>CategoryService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/EmailService.java'>EmailService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/HashService.java'>HashService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/ProductService.java'>ProductService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/RoleService.java'>RoleService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/SellerService.java'>SellerService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/SessionService.java'>SessionService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/service/UserService.java'>UserService.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- util Submodule -->
											<details>
												<summary><b>util</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.util</b></code>
													<table style='width: 100%; border-collapse: collapse;'>
													<thead>
														<tr style='background-color: #f8f9fa;'>
															<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
															<th style='text-align: left; padding: 8px;'>Summary</th>
														</tr>
													</thead>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/util/SessionCookieUtil.java'>SessionCookieUtil.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
														<tr style='border-bottom: 1px solid #eee;'>
															<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/util/TokenGeneratorUtil.java'>TokenGeneratorUtil.java</a></b></td>
															<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
														</tr>
													</table>
												</blockquote>
											</details>
											<!-- dto Submodule -->
											<details>
												<summary><b>dto</b></summary>
												<blockquote>
													<div class='directory-path' style='padding: 8px 0; color: #666;'>
														<code><b>⦿ backend.src.main.java.com.dto</b></code>
													<!-- address Submodule -->
													<details>
														<summary><b>address</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.address</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/address/AddressCreateRequest.java'>AddressCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/address/AddressResponse.java'>AddressResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/address/AddressUpdateRequest.java'>AddressUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- admin Submodule -->
													<details>
														<summary><b>admin</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.admin</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/admin/AdminCreateRequest.java'>AdminCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/admin/AdminResponse.java'>AdminResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/admin/AdminUpdateRequest.java'>AdminUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- auth Submodule -->
													<details>
														<summary><b>auth</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.auth</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/auth/EmailRequest.java'>EmailRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/auth/LoginRequest.java'>LoginRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/auth/OtpRequest.java'>OtpRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/auth/RegisterRequest.java'>RegisterRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/auth/ResetPasswordRequest.java'>ResetPasswordRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/auth/VerificationTokenRequest.java'>VerificationTokenRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- cart Submodule -->
													<details>
														<summary><b>cart</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.cart</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/cart/CartCreateRequest.java'>CartCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/cart/CartResponse.java'>CartResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/cart/CartUpdateRequest.java'>CartUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- category Submodule -->
													<details>
														<summary><b>category</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.category</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/category/CategoryCreateRequest.java'>CategoryCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/category/CategoryResponse.java'>CategoryResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/category/CategoryUpdateRequest.java'>CategoryUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/category/CategoryWithProductResponse.java'>CategoryWithProductResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- city Submodule -->
													<details>
														<summary><b>city</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.city</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/city/CityCreateRequest.java'>CityCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/city/CityResponse.java'>CityResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/city/CityUpdateRequest.java'>CityUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- customer Submodule -->
													<details>
														<summary><b>customer</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.customer</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/customer/CustomerCreateRequest.java'>CustomerCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/customer/CustomerResponse.java'>CustomerResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/customer/CustomerUpdateRequest.java'>CustomerUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- product Submodule -->
													<details>
														<summary><b>product</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.product</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/product/ProductCreateRequest.java'>ProductCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/product/ProductResponse.java'>ProductResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/product/ProductSummaryResponse.java'>ProductSummaryResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/product/ProductUpdateRequest.java'>ProductUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
															<!-- variation Submodule -->
															<details>
																<summary><b>variation</b></summary>
																<blockquote>
																	<div class='directory-path' style='padding: 8px 0; color: #666;'>
																		<code><b>⦿ backend.src.main.java.com.dto.product.variation</b></code>
																	<table style='width: 100%; border-collapse: collapse;'>
																	<thead>
																		<tr style='background-color: #f8f9fa;'>
																			<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																			<th style='text-align: left; padding: 8px;'>Summary</th>
																		</tr>
																	</thead>
																		<tr style='border-bottom: 1px solid #eee;'>
																			<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/product/variation/VariationCreateRequest.java'>VariationCreateRequest.java</a></b></td>
																			<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																		</tr>
																		<tr style='border-bottom: 1px solid #eee;'>
																			<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/product/variation/VariationResponse.java'>VariationResponse.java</a></b></td>
																			<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																		</tr>
																		<tr style='border-bottom: 1px solid #eee;'>
																			<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/product/variation/VariationUpdateRequest.java'>VariationUpdateRequest.java</a></b></td>
																			<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																		</tr>
																	</table>
																</blockquote>
															</details>
														</blockquote>
													</details>
													<!-- role Submodule -->
													<details>
														<summary><b>role</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.role</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/role/RoleCreateRequest.java'>RoleCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/role/RoleResponse.java'>RoleResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/role/RoleUpdateRequest.java'>RoleUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- seller Submodule -->
													<details>
														<summary><b>seller</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.seller</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/seller/SellerCreateRequest.java'>SellerCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/seller/SellerResponse.java'>SellerResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/seller/SellerUpdateRequest.java'>SellerUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- session Submodule -->
													<details>
														<summary><b>session</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.session</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/session/SessionCreateRequest.java'>SessionCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/session/SessionResponse.java'>SessionResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/session/SessionUpdateRequest.java'>SessionUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
													<!-- user Submodule -->
													<details>
														<summary><b>user</b></summary>
														<blockquote>
															<div class='directory-path' style='padding: 8px 0; color: #666;'>
																<code><b>⦿ backend.src.main.java.com.dto.user</b></code>
															<table style='width: 100%; border-collapse: collapse;'>
															<thead>
																<tr style='background-color: #f8f9fa;'>
																	<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
																	<th style='text-align: left; padding: 8px;'>Summary</th>
																</tr>
															</thead>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/user/UserCreateRequest.java'>UserCreateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/user/UserResponse.java'>UserResponse.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
																<tr style='border-bottom: 1px solid #eee;'>
																	<td style='padding: 8px;'><b><a href='/backend/src/main/java/com/dto/user/UserUpdateRequest.java'>UserUpdateRequest.java</a></b></td>
																	<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
																</tr>
															</table>
														</blockquote>
													</details>
												</blockquote>
											</details>
										</blockquote>
									</details>
								</blockquote>
							</details>
						</blockquote>
					</details>
				</blockquote>
			</details>
		</blockquote>
	</details>
	<!-- frontend Submodule -->
	<details>
		<summary><b>frontend</b></summary>
		<blockquote>
			<div class='directory-path' style='padding: 8px 0; color: #666;'>
				<code><b>⦿ frontend</b></code>
			<table style='width: 100%; border-collapse: collapse;'>
			<thead>
				<tr style='background-color: #f8f9fa;'>
					<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
					<th style='text-align: left; padding: 8px;'>Summary</th>
				</tr>
			</thead>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/frontend/.env.development'>.env.development</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/frontend/.env.production'>.env.production</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/frontend/.prettierrc.json'>.prettierrc.json</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/frontend/index.html'>index.html</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/frontend/jsconfig.json'>jsconfig.json</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/frontend/package-lock.json'>package-lock.json</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/frontend/package.json'>package.json</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
				<tr style='border-bottom: 1px solid #eee;'>
					<td style='padding: 8px;'><b><a href='/frontend/vite.config.js'>vite.config.js</a></b></td>
					<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
				</tr>
			</table>
			<!-- src Submodule -->
			<details>
				<summary><b>src</b></summary>
				<blockquote>
					<div class='directory-path' style='padding: 8px 0; color: #666;'>
						<code><b>⦿ frontend.src</b></code>
					<table style='width: 100%; border-collapse: collapse;'>
					<thead>
						<tr style='background-color: #f8f9fa;'>
							<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
							<th style='text-align: left; padding: 8px;'>Summary</th>
						</tr>
					</thead>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='/frontend/src/App.vue'>App.vue</a></b></td>
							<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
						</tr>
						<tr style='border-bottom: 1px solid #eee;'>
							<td style='padding: 8px;'><b><a href='/frontend/src/main.js'>main.js</a></b></td>
							<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
						</tr>
					</table>
					<!-- router Submodule -->
					<details>
						<summary><b>router</b></summary>
						<blockquote>
							<div class='directory-path' style='padding: 8px 0; color: #666;'>
								<code><b>⦿ frontend.src.router</b></code>
							<table style='width: 100%; border-collapse: collapse;'>
							<thead>
								<tr style='background-color: #f8f9fa;'>
									<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
									<th style='text-align: left; padding: 8px;'>Summary</th>
								</tr>
							</thead>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='/frontend/src/router/index.js'>index.js</a></b></td>
									<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
								</tr>
							</table>
						</blockquote>
					</details>
					<!-- stores Submodule -->
					<details>
						<summary><b>stores</b></summary>
						<blockquote>
							<div class='directory-path' style='padding: 8px 0; color: #666;'>
								<code><b>⦿ frontend.src.stores</b></code>
							<table style='width: 100%; border-collapse: collapse;'>
							<thead>
								<tr style='background-color: #f8f9fa;'>
									<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
									<th style='text-align: left; padding: 8px;'>Summary</th>
								</tr>
							</thead>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='/frontend/src/stores/authStore.js'>authStore.js</a></b></td>
									<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
								</tr>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='/frontend/src/stores/cartStore.js'>cartStore.js</a></b></td>
									<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
								</tr>
							</table>
						</blockquote>
					</details>
					<!-- styles Submodule -->
					<details>
						<summary><b>styles</b></summary>
						<blockquote>
							<div class='directory-path' style='padding: 8px 0; color: #666;'>
								<code><b>⦿ frontend.src.styles</b></code>
							<table style='width: 100%; border-collapse: collapse;'>
							<thead>
								<tr style='background-color: #f8f9fa;'>
									<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
									<th style='text-align: left; padding: 8px;'>Summary</th>
								</tr>
							</thead>
								<tr style='border-bottom: 1px solid #eee;'>
									<td style='padding: 8px;'><b><a href='/frontend/src/styles/custom.scss'>custom.scss</a></b></td>
									<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
								</tr>
							</table>
						</blockquote>
					</details>
					<!-- components Submodule -->
					<details>
						<summary><b>components</b></summary>
						<blockquote>
							<div class='directory-path' style='padding: 8px 0; color: #666;'>
								<code><b>⦿ frontend.src.components</b></code>
							<!-- account Submodule -->
							<details>
								<summary><b>account</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.account</b></code>
									<!-- layout Submodule -->
									<details>
										<summary><b>layout</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.account.layout</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/account/layout/AccountLayout.vue'>AccountLayout.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.account.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/account/pages/Account.vue'>Account.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/account/pages/Address.vue'>Address.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/account/pages/Payment.vue'>Payment.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- sections Submodule -->
									<details>
										<summary><b>sections</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.account.sections</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/account/sections/AccountSidebar.vue'>AccountSidebar.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- admin Submodule -->
							<details>
								<summary><b>admin</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.admin</b></code>
									<!-- layout Submodule -->
									<details>
										<summary><b>layout</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.admin.layout</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/admin/layout/AdminLayout.vue'>AdminLayout.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.admin.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/admin/pages/AdminDashboard.vue'>AdminDashboard.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/admin/pages/AdminOrders.vue'>AdminOrders.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/admin/pages/AdminProducts.vue'>AdminProducts.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- sections Submodule -->
									<details>
										<summary><b>sections</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.admin.sections</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/admin/sections/AdminSidebar.vue'>AdminSidebar.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- auth Submodule -->
							<details>
								<summary><b>auth</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.auth</b></code>
									<!-- layout Submodule -->
									<details>
										<summary><b>layout</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.auth.layout</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/auth/layout/AuthLayout.vue'>AuthLayout.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.auth.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/auth/pages/ForgotPassword.vue'>ForgotPassword.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/auth/pages/Login.vue'>Login.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/auth/pages/ResetPassword.vue'>ResetPassword.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/auth/pages/Signup.vue'>Signup.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/auth/pages/VerifyOtp.vue'>VerifyOtp.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- base Submodule -->
							<details>
								<summary><b>base</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.base</b></code>
									<!-- layout Submodule -->
									<details>
										<summary><b>layout</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.base.layout</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/base/layout/Generic.vue'>Generic.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- sections Submodule -->
									<details>
										<summary><b>sections</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.base.sections</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/base/sections/Footer.vue'>Footer.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/base/sections/Navbar.vue'>Navbar.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- cart Submodule -->
							<details>
								<summary><b>cart</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.cart</b></code>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.cart.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/cart/pages/Cart.vue'>Cart.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- sections Submodule -->
									<details>
										<summary><b>sections</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.cart.sections</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/cart/sections/CartDisplay.vue'>CartDisplay.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/cart/sections/CartDisplayItem.vue'>CartDisplayItem.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- homepage Submodule -->
							<details>
								<summary><b>homepage</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.homepage</b></code>
									<!-- layout Submodule -->
									<details>
										<summary><b>layout</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.homepage.layout</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/homepage/layout/HomepageLayout.vue'>HomepageLayout.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.homepage.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/homepage/pages/Homepage.vue'>Homepage.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- sections Submodule -->
									<details>
										<summary><b>sections</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.homepage.sections</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/homepage/sections/BestSelling.vue'>BestSelling.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/homepage/sections/HomepageSidebar.vue'>HomepageSidebar.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/homepage/sections/NewProducts.vue'>NewProducts.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/homepage/sections/ProductByCat.vue'>ProductByCat.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- order Submodule -->
							<details>
								<summary><b>order</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.order</b></code>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.order.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/order/pages/OrderDetail.vue'>OrderDetail.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/order/pages/OrderStatus.vue'>OrderStatus.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- sections Submodule -->
									<details>
										<summary><b>sections</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.order.sections</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/order/sections/StatusNavbar.vue'>StatusNavbar.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- product Submodule -->
							<details>
								<summary><b>product</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.product</b></code>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.product.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/product/pages/ProductDetail.vue'>ProductDetail.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- sections Submodule -->
									<details>
										<summary><b>sections</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.product.sections</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/product/sections/AllProducts.vue'>AllProducts.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/product/sections/DisplayItem.vue'>DisplayItem.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/product/sections/ExtraProducts.vue'>ExtraProducts.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/product/sections/ProductDisplay.vue'>ProductDisplay.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/product/sections/VariantSelection.vue'>VariantSelection.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- search Submodule -->
							<details>
								<summary><b>search</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.search</b></code>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.search.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/search/pages/Search.vue'>Search.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
							<!-- seller Submodule -->
							<details>
								<summary><b>seller</b></summary>
								<blockquote>
									<div class='directory-path' style='padding: 8px 0; color: #666;'>
										<code><b>⦿ frontend.src.components.seller</b></code>
									<!-- layout Submodule -->
									<details>
										<summary><b>layout</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.seller.layout</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/seller/layout/SellerLayout.vue'>SellerLayout.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- pages Submodule -->
									<details>
										<summary><b>pages</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.seller.pages</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/seller/pages/SellerDashboard.vue'>SellerDashboard.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/seller/pages/SellerOrders.vue'>SellerOrders.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/seller/pages/SellerProducts.vue'>SellerProducts.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
									<!-- sections Submodule -->
									<details>
										<summary><b>sections</b></summary>
										<blockquote>
											<div class='directory-path' style='padding: 8px 0; color: #666;'>
												<code><b>⦿ frontend.src.components.seller.sections</b></code>
											<table style='width: 100%; border-collapse: collapse;'>
											<thead>
												<tr style='background-color: #f8f9fa;'>
													<th style='width: 30%; text-align: left; padding: 8px;'>File Name</th>
													<th style='text-align: left; padding: 8px;'>Summary</th>
												</tr>
											</thead>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/seller/sections/AuthActiveProducts.vue'>AuthActiveProducts.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/seller/sections/AuthDisplayItem.vue'>AuthDisplayItem.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/seller/sections/AuthInactiveProducts.vue'>AuthInactiveProducts.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
												<tr style='border-bottom: 1px solid #eee;'>
													<td style='padding: 8px;'><b><a href='/frontend/src/components/seller/sections/SellerSidebar.vue'>SellerSidebar.vue</a></b></td>
													<td style='padding: 8px;'>Code>❯ REPLACE-ME</code></td>
												</tr>
											</table>
										</blockquote>
									</details>
								</blockquote>
							</details>
						</blockquote>
					</details>
				</blockquote>
			</details>
		</blockquote>
	</details>
</details>

---

## Getting Started

### Prerequisites

This project requires the following dependencies:

- **Programming Language:** Java
- **Package Manager:** Gradle, Npm

### For local development

1. **Clone the repository:**

    ```sh
    ❯ git clone https://github.com/SilencedFrost/EasyEat
    ```

2. **Navigate to the project directory:**

    ```sh
    ❯ cd EasyEat
    ```

3. **Deploy database schema and mock data:**

	- Create Postgres database named EasyEat
	- Within it, open query tool
	- Open backend/database/Schema.sql
	- Run all
	- Open backend/database/Mock_data.sql
	- Run all

5. **Build applications.properties:**

	```sh
	❯ cp backend/src/main/resources/application.properties.example backend/src/main/resources/application.properties
	```
	
	- Edit the placeholder infos within the new application.properties file to match your local env

4. **Run the backend:**

	- Open a new terminal at root
	
	```sh
	❯ cd backend/
	❯ ./gradlew bootRun
	```
	
5. **Run the frontend:**

	- Open a new terminal at root

	```sh
	❯ cd frontend/
	❯ npm install
	❯ npm run dev
	```
6. **Access the frontend:**

http://localhost:5173/

(Vue default port)

## Contributing

- **🐛 [Report Issues](https://github.com/SilencedFrost/EasyEat/issues)**: Submit bugs found or log feature requests for the `EasyEat` project.
- **💡 [Submit Pull Requests](https://github.com/SilencedFrost/EasyEat/pulls)**: Review open PRs, and submit your own PRs.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your LOCAL account.
2. **Clone Locally**: Clone the forked repository to your local machine using a git client.
   ```sh
   git clone .
   ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
   ```sh
   git checkout -b new-feature-x
   ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
   ```sh
   git commit -m 'Implemented new feature x.'
   ```
6. **Push to LOCAL**: Push the changes to your forked repository.
   ```sh
   git push origin new-feature-x
   ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch. Congratulations on your contribution!

</details>

---

## Acknowledgments

### Credit

- Contributors: [SilencedFrost](https://github.com/SilencedFrost), [WinGG](https://github.com/WinGG2809), [minesan](https://github.com/minesan191132), [HVC-max](https://github.com/HVC-max), [nguyenlenganha](https://github.com/nguyenlenganha150207)

<div align="right">

[![][back-to-top]](#top)

</div>

[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square

---
