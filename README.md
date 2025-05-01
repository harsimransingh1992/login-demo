# PeriDesk - Dental Management Software

PeriDesk is a comprehensive dental practice management system designed to streamline patient management, appointments, and clinical examinations.

## Features

- **Patient Management**
  - Patient registration and profile management
  - Detailed patient history tracking
  - Check-in/Check-out system
  - Patient search and filtering

- **Appointment Scheduling**
  - Interactive calendar view
  - Real-time appointment tracking
  - Doctor assignment
  - Time slot management

- **Clinical Examination**
  - Detailed tooth examination records
  - Clinical condition tracking
  - Treatment planning
  - Progress monitoring

- **Administrative Features**
  - User management
  - Doctor management
  - Procedure pricing
  - Role-based access control

## Technology Stack

- **Backend**
  - Java 8
  - Spring Boot
  - Spring Security
  - Spring Data JPA
  - MySQL Database

- **Frontend**
  - JSP (JavaServer Pages)
  - FullCalendar.js
  - Bootstrap
  - Font Awesome
  - Custom CSS

## Prerequisites

- Java 8 or higher
- Maven 3.6 or higher
- MySQL 5.7 or higher
- Modern web browser

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/harsimransingh1992/login-demo.git
   ```

2. Configure the database:
   - Create a MySQL database named `peridesk`
   - Update the database credentials in `src/main/resources/application.properties`

3. Build the project:
   ```bash
   mvn clean install
   ```

4. Run the application:
   ```bash
   mvn spring-boot:run
   ```

5. Access the application:
   - Open your browser and navigate to `http://localhost:8080`
   - Default admin credentials:
     - Username: admin
     - Password: admin123

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/example/logindemo/
│   │       ├── config/         # Configuration classes
│   │       ├── controller/     # MVC controllers
│   │       ├── model/          # Entity classes
│   │       ├── repository/     # JPA repositories
│   │       ├── service/        # Business logic
│   │       └── util/           # Utility classes
│   ├── resources/
│   │   └── application.properties
│   └── webapp/
│       ├── WEB-INF/
│       │   └── views/          # JSP pages
│       ├── css/                # Stylesheets
│       ├── js/                 # JavaScript files
│       └── images/             # Static images
└── test/                       # Test classes
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Harsimran Singh - [@harsimransingh1992](https://github.com/harsimransingh1992)

Project Link: [https://github.com/harsimransingh1992/login-demo](https://github.com/harsimransingh1992/login-demo) 