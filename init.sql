-- Users Table
CREATE TABLE IF NOT EXISTS Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50),
    email VARCHAR(100),
    password VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(255),
    birth_date DATE
);

-- Hosts Table
CREATE TABLE Hosts (
    id INT PRIMARY KEY,
    user_id INT,
    host_description TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Guests Table
CREATE TABLE Guests (
    id INT PRIMARY KEY,
    user_id INT,
    documents_verified BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Admins Table
CREATE TABLE Admins (
    id INT PRIMARY KEY,
    user_id INT,
    admin_role VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Locations Table
CREATE TABLE Locations (
    id INT PRIMARY KEY,
    city VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(10)
);

-- Accommodations Table
CREATE TABLE Accommodations (
    id INT PRIMARY KEY,
    host_id INT,
    location_id INT,
    title VARCHAR(100),
    description TEXT,
    address VARCHAR(255),
    price_per_night DECIMAL(8, 2),
    max_guests INT,
    availability BOOLEAN,
    policy_id INT,
    FOREIGN KEY (host_id) REFERENCES Hosts(id),
    FOREIGN KEY (location_id) REFERENCES Locations(id)
);

-- Amenities Table
CREATE TABLE Amenities (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

-- Accommodation_Amenities Table
CREATE TABLE Accommodation_Amenities (
    accommodation_id INT,
    amenity_id INT,
    PRIMARY KEY (accommodation_id, amenity_id),
    FOREIGN KEY (accommodation_id) REFERENCES Accommodations(id),
    FOREIGN KEY (amenity_id) REFERENCES Amenities(id)
);

-- House_Rules Table
CREATE TABLE House_Rules (
    id INT PRIMARY KEY,
    accommodation_id INT,
    rule_text TEXT,
    FOREIGN KEY (accommodation_id) REFERENCES Accommodations(id)
);

-- Neighborhood_Info Table
CREATE TABLE Neighborhood_Info (
    id INT PRIMARY KEY,
    accommodation_id INT,
    info_text TEXT,
    FOREIGN KEY (accommodation_id) REFERENCES Accommodations(id)
);

-- Bookings Table
CREATE TABLE Bookings (
    id INT PRIMARY KEY,
    guest_id INT,
    accommodation_id INT,
    checkin_date DATE,
    checkout_date DATE,
    number_of_guests INT,
    status VARCHAR(20) CHECK(status IN ('Confirmed', 'Pending', 'Cancelled')),
    FOREIGN KEY (guest_id) REFERENCES Guests(id),
    FOREIGN KEY (accommodation_id) REFERENCES Accommodations(id)
);

-- Payments Table
CREATE TABLE Payments (
    id INT PRIMARY KEY,
    booking_id INT,
    payer_id INT,
    payment_method VARCHAR(50),
    payment_date DATE,
    amount DECIMAL(10, 2),
    method_id INT,
    fee_id INT,
    FOREIGN KEY (booking_id) REFERENCES Bookings(id),
    FOREIGN KEY (payer_id) REFERENCES Users(id)
);

-- Reviews Table
CREATE TABLE Reviews (
    id INT PRIMARY KEY,
    guest_id INT,
    accommodation_id INT,
    rating INT,
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (guest_id) REFERENCES Guests(id),
    FOREIGN KEY (accommodation_id) REFERENCES Accommodations(id)
);

-- Pictures Table
CREATE TABLE Pictures (
    id INT PRIMARY KEY,
    accommodation_id INT,
    host_id INT,
    guest_id INT,
    url VARCHAR(255),
    upload_date DATE,
    FOREIGN KEY (accommodation_id) REFERENCES Accommodations(id),
    FOREIGN KEY (host_id) REFERENCES Hosts(id),
    FOREIGN KEY (guest_id) REFERENCES Guests(id)
);

-- Languages Table
CREATE TABLE Languages (
    id INT PRIMARY KEY,
    language_name VARCHAR(50) UNIQUE
);

-- User_Languages Table (Unified for Hosts and Guests)
CREATE TABLE User_Languages (
    user_id INT,
    language_id INT,
    PRIMARY KEY (user_id, language_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (language_id) REFERENCES Languages(id)
);

-- Cancellation_Policies Table
CREATE TABLE Cancellation_Policies (
    id INT PRIMARY KEY,
    description TEXT
);

-- Discounts Table
CREATE TABLE Discounts (
    id INT PRIMARY KEY,
    accommodation_id INT,
    discount_percentage DECIMAL(5, 2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (accommodation_id) REFERENCES Accommodations(id)
);

-- User_Scores Table (Unified for Hosts and Guests)
CREATE TABLE User_Scores (
    id INT PRIMARY KEY,
    user_id INT,
    rating INT,
    rating_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Support_Requests Table
CREATE TABLE Support_Requests (
    id INT PRIMARY KEY,
    guest_id INT,
    admin_id INT,
    accommodation_id INT,
    request_type VARCHAR(50),
    description TEXT,
    request_date DATE,
    status VARCHAR(20) CHECK(status IN ('Open', 'Closed', 'Pending')),
    FOREIGN KEY (guest_id) REFERENCES Guests(id),
    FOREIGN KEY (admin_id) REFERENCES Admins(id),
    FOREIGN KEY (accommodation_id) REFERENCES Accommodations(id)
);

-- Payment_Methods Table
CREATE TABLE Payment_Methods (
    id INT PRIMARY KEY,
    method_name VARCHAR(50),
    description TEXT
);

-- Transaction_Fees Table
CREATE TABLE Transaction_Fees (
    id INT PRIMARY KEY,
    fee_percentage DECIMAL(4, 2)
);


INSERT INTO Users (id, name, email, password, phone, address, birth_date) VALUES 
(1, 'Alice Bianchi', 'alice.bianchi@example.com', 'password123', '3312345678', 'Via Roma 10, Milano', '1985-06-15'),
(2, 'Marco Rossi', 'marco.rossi@example.com', 'securepass456', '3298765432', 'Via Milano 22, Torino', '1990-03-22'),
(3, 'Luca Verdi', 'luca.verdi@example.com', 'mypassword789', '3345566778', 'Viale delle Rose 15, Roma', '1982-09-05'),
(4, 'Giulia Neri', 'giulia.neri@example.com', 'giuliapass123', '3356677889', 'Via Mazzini 12, Firenze', '1991-07-19'),
(5, 'Francesco Giordano', 'francesco.giordano@example.com', 'francescopass321', '3367788990', 'Piazza del Duomo 5, Napoli', '1988-11-30'),
(6, 'Giovanni Marini', 'giovanni.marini@example.com', 'giovanni2024pass', '3378899001', 'Corso Italia 30, Bologna', '1990-12-12'),
(7, 'Valentina Russo', 'valentina.russo@example.com', 'valentinapass2024', '3389900112', 'Via Verdi 3, Palermo', '1986-04-25'),
(8, 'Antonio Romano', 'antonio.romano@example.com', 'antonioromano123', '3390011223', 'Piazza San Marco 10, Venezia', '1993-02-10'),
(9, 'Silvia Conti', 'silvia.conti@example.com', 'silviapassword456', '3401122334', 'Via Dante 8, Firenze', '1983-08-14'),
(10, 'Andrea De Luca', 'andrea.deluca@example.com', 'andrea2023pass', '3412233445', 'Viale Trastevere 22, Roma', '1987-12-09'),
(11, 'Elena Costa', 'elena.costa@example.com', 'elenacosta321', '3423344556', 'Corso Garibaldi 12, Torino', '1992-11-05'),
(12, 'Matteo Sanna', 'matteo.sanna@example.com', 'matteosanna456', '3434455667', 'Via Monti 18, Cagliari', '1991-01-25'),
(13, 'Martina Gallo', 'martina.gallo@example.com', 'martinapass789', '3445566778', 'Piazza Navona 6, Roma', '1989-04-10'),
(14, 'Salvatore Ferrara', 'salvatore.ferrara@example.com', 'salvatorepass123', '3456677889', 'Via Magenta 1, Milano', '1990-02-14'),
(15, 'Caterina Barbieri', 'caterina.barbieri@example.com', 'caterinapass321', '3467788990', 'Via San Giovanni 7, Bologna', '1986-06-30'),
(16, 'Paolo Mancini', 'paolo.mancini@example.com', 'paolopassword123', '3478899001', 'Viale Liberta 3, Genova', '1985-12-18'),
(17, 'Francesca Moretti', 'francesca.moretti@example.com', 'francescapass765', '3489900112', 'Corso Venezia 11, Milano', '1987-07-05'),
(18, 'Alessandro Ricci', 'alessandro.ricci@example.com', 'alessandropass2023', '3490011223', 'Via Carlo Alberto 5, Torino', '1983-11-16'),
(19, 'Veronica Di Stefano', 'veronica.distefano@example.com', 'veronicadpass456', '3501122334', 'Via degli Artisti 25, Napoli', '1992-09-22'),
(20, 'Stefano Pugliese', 'stefano.pugliese@example.com', 'stefanopass789', '3512233445', 'Piazza della Repubblica 9, Roma', '1991-10-05'),
(21, 'Roberta Villa', 'roberta.villa@example.com', 'robertopassword123', '3523344556', 'Via Monteverde 4, Roma', '1988-04-21'),
(22, 'Luigi Rizzo', 'luigi.rizzo@example.com', 'luigirizzo456', '3534455667', 'Viale Piave 12, Catania', '1993-06-03'),
(23, 'Simona Fontana', 'simona.fontana@example.com', 'simonapassword123', '3545566778', 'Via Nazionale 8, Bologna', '1984-12-13'),
(24, 'Massimo Bassi', 'massimo.bassi@example.com', 'massimobassi321', '3556677889', 'Corso Europa 10, Firenze', '1990-02-19'),
(25, 'Isabella Russo', 'isabella.russo@example.com', 'isabellapass456', '3567788990', 'Via Roma 23, Milano', '1987-07-14');

INSERT INTO Hosts (id, user_id, host_description) VALUES 
(1, 1, 'Alice has been hosting guests for 5 years and loves sharing her city with travelers.'),
(2, 2, 'Marco offers cozy accommodations with a personal touch.'),
(3, 3, 'Luca has a modern apartment with stunning views of the city skyline.'),
(4, 4, 'Giulia is an expert host who loves welcoming people from all over the world into her spacious apartment.'),
(5, 5, 'Francesco offers stylish rooms and impeccable service for an unforgettable stay.'),
(6, 6, 'Giovanni is a friendly host who enjoys sharing the secrets of his city with travelers.'),
(7, 7, 'Valentina runs a charming bed and breakfast with homemade breakfast served every morning.'),
(8, 8, 'Antonio is passionate about hospitality and has a home full of comfort and style.'),
(9, 9, 'Silvia offers a peaceful and family-friendly environment, perfect for those seeking relaxation.'),
(10, 10, 'Andrea has a modern loft, ideal for families or groups of friends.'),
(11, 11, 'Elena is highly praised for her hospitality and warm welcome to all guests.'),
(12, 12, 'Matteo offers a beautiful home with a large garden, perfect for outdoor lovers.'),
(13, 13, 'Martina runs a gorgeous apartment with sea views, ideal for a romantic getaway.'),
(14, 14, 'Salvatore offers modern rooms and a peaceful location in the city.'),
(15, 15, 'Caterina has a historic home with refined interiors, welcoming guests with great passion.'),
(16, 16, 'Paolo is an experienced host who provides elegant accommodations and high-quality service.'),
(17, 17, 'Francesca offers well-furnished apartments and unique hospitality, making every stay special.'),
(18, 18, 'Alessandro has a rustic house immersed in nature, perfect for those seeking peace and quiet.'),
(19, 19, 'Veronica offers a cozy apartment with a breathtaking view in the city center.'),
(20, 20, 'Stefano has a modern villa with a pool, ideal for families and groups of friends.'),
(21, 21, 'Roberta offers spacious rooms and a breakfast made with fresh local ingredients.'),
(22, 22, 'Luigi has a stylish apartment in the heart of the city, just steps away from major tourist attractions.'),
(23, 23, 'Simona has a rustic home combining modern comforts with traditional charm.'),
(24, 24, 'Massimo offers a beautiful countryside home, perfect for those looking for a peaceful retreat.'),
(25, 25, 'Isabella provides a welcoming and comfortable stay with warm hospitality.');

INSERT INTO Guests (id, user_id, documents_verified) VALUES 
(1, 1, TRUE),
(2, 2, FALSE),
(3, 3, TRUE),
(4, 4, TRUE),
(5, 5, FALSE),
(6, 6, TRUE),
(7, 7, TRUE),
(8, 8, FALSE),
(9, 9, TRUE),
(10, 10, FALSE),
(11, 11, TRUE),
(12, 12, FALSE),
(13, 13, TRUE),
(14, 14, FALSE),
(15, 15, TRUE),
(16, 16, FALSE),
(17, 17, TRUE),
(18, 18, FALSE),
(19, 19, TRUE),
(20, 20, FALSE),
(21, 21, TRUE),
(22, 22, FALSE),
(23, 23, TRUE),
(24, 24, FALSE),
(25, 25, TRUE);

INSERT INTO Admins (id, user_id, admin_role) VALUES 
(1, 1, 'Support Specialist'),
(2, 2, 'System Administrator'),
(3, 3, 'Content Moderator'),
(4, 4, 'Support Specialist'),
(5, 5, 'System Administrator'),
(6, 6, 'Content Moderator'),
(7, 7, 'Support Specialist'),
(8, 8, 'System Administrator'),
(9, 9, 'Content Moderator'),
(10, 10, 'Support Specialist'),
(11, 11, 'System Administrator'),
(12, 12, 'Content Moderator'),
(13, 13, 'Support Specialist'),
(14, 14, 'System Administrator'),
(15, 15, 'Content Moderator'),
(16, 16, 'Support Specialist'),
(17, 17, 'System Administrator'),
(18, 18, 'Content Moderator'),
(19, 19, 'Support Specialist'),
(20, 20, 'System Administrator'),
(21, 21, 'Content Moderator'),
(22, 22, 'Support Specialist'),
(23, 23, 'System Administrator'),
(24, 24, 'Content Moderator'),
(25, 25, 'Support Specialist');

-- Locations
INSERT INTO Locations (id, city, country, postal_code) VALUES 
(1, 'New York', 'USA', '10001'),
(2, 'London', 'UK', 'EC1A1BB'),
(3, 'Tokyo', 'Japan', '100-0001'),
(4, 'Paris', 'France', '75001'),
(5, 'Berlin', 'Germany', '10115'),
(6, 'Sydney', 'Australia', '2000'),
(7, 'Barcelona', 'Spain', '08001'),
(8, 'Rome', 'Italy', '00100'),
(9, 'Amsterdam', 'Netherlands', '1012'),
(10, 'Los Angeles', 'USA', '90001'),
(11, 'Madrid', 'Spain', '28001'),
(12, 'San Francisco', 'USA', '94101'),
(13, 'Toronto', 'Canada', 'M5A 1A1'),
(14, 'Dubai', 'UAE', '00001'),
(15, 'Hong Kong', 'China', '00001'),
(16, 'Seoul', 'South Korea', '04522'),
(17, 'Bangkok', 'Thailand', '10100'),
(18, 'Moscow', 'Russia', '101000'),
(19, 'Singapore', 'Singapore', '018961'),
(20, 'Rome', 'Italy', '00123'),
(21, 'Copenhagen', 'Denmark', '1000'),
(22, 'Dubai', 'UAE', '00200'),
(23, 'Vienna', 'Austria', '1010'),
(24, 'Lisbon', 'Portugal', '1100'),
(25, 'Mexico City', 'Mexico', '01000');

-- Accommodations
INSERT INTO Accommodations (id, host_id, location_id, title, description, address, price_per_night, max_guests, availability, policy_id) VALUES 
(1, 1, 1, 'Cozy Apartment in NYC', 'A beautiful apartment in the heart of NYC.', '123 Main St, New York', 120.00, 2, TRUE, 1),
(2, 2, 2, 'Luxury Flat in London', 'A modern flat with all amenities.', '456 Elm St, London', 200.00, 4, TRUE, 2),
(3, 3, 3, 'Traditional Japanese Home', 'A serene home in the center of Tokyo.', '789 Oak St, Tokyo', 150.00, 3, FALSE, 3),
(4, 4, 4, 'Charming Parisian Apartment', 'Located in the heart of Paris, close to Eiffel Tower.', '10 Rue de Paris, Paris', 180.00, 2, TRUE, 1),
(5, 5, 5, 'Modern Berlin Loft', 'Stylish loft with a great view of the city.', '22 Berlin Street, Berlin', 100.00, 2, TRUE, 2),
(6, 6, 6, 'Coastal Sydney Retreat', 'Spacious home near the beach in Sydney.', '11 Bondi Rd, Sydney', 220.00, 6, TRUE, 1),
(7, 7, 7, 'Barcelona City Center Flat', 'Vibrant flat near La Rambla and the beach.', '20 Barcelona Ave, Barcelona', 150.00, 4, TRUE, 2),
(8, 8, 8, 'Rustic Roman Villa', 'Beautiful villa in the Italian countryside.', '15 Via Roma, Rome', 250.00, 8, TRUE, 3),
(9, 9, 9, 'Charming Canal House in Amsterdam', 'Located along the picturesque canals of Amsterdam.', '25 Canal St, Amsterdam', 175.00, 3, TRUE, 1),
(10, 10, 10, 'Luxury Villa in LA', 'Modern villa with a pool and panoramic views of Los Angeles.', '50 Sunset Blvd, Los Angeles', 350.00, 6, TRUE, 2),
(11, 11, 11, 'Madrid City Apartment', 'Spacious apartment located near Retiro Park.', '8 Madrid Square, Madrid', 130.00, 3, TRUE, 3),
(12, 12, 12, 'San Francisco Skyline View Condo', 'Condo with a breathtaking view of the Golden Gate Bridge.', '33 Market St, San Francisco', 200.00, 4, TRUE, 1),
(13, 13, 13, 'Cozy Toronto Cottage', 'Relaxing cottage with a fireplace in the suburbs of Toronto.', '14 Lakeview Rd, Toronto', 140.00, 2, TRUE, 2),
(14, 14, 14, 'Exclusive Dubai Penthouse', 'A penthouse with luxury facilities in the heart of Dubai.', '5 Palm Jumeirah, Dubai', 400.00, 5, TRUE, 1),
(15, 15, 15, 'Stylish Hong Kong Apartment', 'Modern apartment with a great city view.', '7 Kowloon St, Hong Kong', 250.00, 4, TRUE, 3),
(16, 16, 16, 'Seoul Downtown Studio', 'Comfortable studio in the heart of Seoul.', '22 Seoul St, Seoul', 120.00, 2, TRUE, 2),
(17, 17, 17, 'Quiet Bangkok Bungalow', 'Peaceful bungalow in the outskirts of Bangkok.', '12 Sukhumvit Rd, Bangkok', 90.00, 2, FALSE, 3),
(18, 18, 18, 'Luxurious Moscow Apartment', 'Luxury apartment with modern amenities in central Moscow.', '25 Red Square, Moscow', 230.00, 3, TRUE, 1),
(19, 19, 19, 'Contemporary Singapore Condo', 'Modern condo in the Marina Bay area.', '10 Marina Blvd, Singapore', 200.00, 4, TRUE, 2),
(20, 20, 20, 'Historic Lisbon Studio', 'Charming studio with a view of the Tagus River.', '30 Baixa St, Lisbon', 130.00, 2, TRUE, 3),
(21, 21, 21, 'Elegant Copenhagen Apartment', 'Luxury apartment close to Tivoli Gardens.', '5 Tivoli St, Copenhagen', 170.00, 4, TRUE, 1),
(22, 22, 22, 'Dubai Beachside Villa', 'Stunning villa with private beach access in Dubai.', '7 Dubai Beach, Dubai', 300.00, 6, TRUE, 2),
(23, 23, 23, 'Vienna Historical Apartment', 'An apartment located near the Schönbrunn Palace.', '20 Vienna St, Vienna', 210.00, 3, TRUE, 3),
(24, 24, 24, 'Charming Mexico City Loft', 'A colorful loft located in the heart of Mexico City.', '25 Zocalo, Mexico City', 160.00, 4, TRUE, 1),
(25, 25, 25, 'Modern New York Studio', 'Studio apartment in a trendy area of NYC.', '9 Broadway, New York', 180.00, 2, TRUE, 2);

-- Amenities
INSERT INTO Amenities (id, name, description) VALUES 
(1, 'WiFi', 'High-speed wireless internet access.'),
(2, 'Air Conditioning', 'Modern air conditioning system.'),
(3, 'Parking', 'Dedicated parking space available.'),
(4, 'Heating', 'Central heating available throughout the property.'),
(5, 'Swimming Pool', 'Private swimming pool for guests use.'),
(6, 'Gym', 'Fully equipped fitness center available.'),
(7, 'Washer', 'Washing machine and dryer available for guests.'),
(8, 'Kitchen', 'Fully equipped kitchen for self-catering.'),
(9, 'Pet-Friendly', 'Accommodation allows pets.'),
(10, 'Balcony', 'Private balcony with stunning views.'),
(11, 'Dishwasher', 'Dishwasher available for guests use.'),
(12, 'Hot Tub', 'Private hot tub for relaxation.'),
(13, 'Fireplace', 'Cozy fireplace available in the living room.'),
(14, 'Elevator', 'Elevator access to all floors in the building.'),
(15, 'Barbecue', 'Outdoor barbecue available for use.'),
(16, 'Sauna', 'Private sauna available in the property.'),
(17, 'Free Parking', 'Free parking available on-site.'),
(18, 'Wheelchair Accessible', 'Accommodation is wheelchair accessible.'),
(19, 'TV', 'Flat-screen TV with cable channels.'),
(20, 'Fridge', 'Refrigerator provided in the accommodation.'),
(21, 'Microwave', 'Microwave available for guests use.'),
(22, 'Oven', 'Oven available in the kitchen.'),
(23, 'Coffee Maker', 'Coffee maker available in the kitchen.'),
(24, 'Outdoor Seating', 'Outdoor seating area available for guests use.'),
(25, 'Security', '24/7 security system for guest safety.');

-- Accommodation_Amenities
INSERT INTO Accommodation_Amenities (accommodation_id, amenity_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 8),
(2, 3), (2, 6), (2, 9), (2, 10),
(3, 4), (3, 7), (3, 5), (3, 11),
(4, 2), (4, 12), (4, 14), (4, 15),
(5, 8), (5, 17), (5, 3), (5, 19),
(6, 13), (6, 16), (6, 18), (6, 20),
(7, 10), (7, 9), (7, 23), (7, 24),
(8, 1), (8, 5), (8, 11), (8, 6);

-- House_Rules
INSERT INTO House_Rules (id, accommodation_id, rule_text) VALUES 
(1, 1, 'No smoking inside the apartment.'),
(2, 2, 'No pets allowed.'),
(3, 3, 'Quiet hours from 10 PM to 8 AM.'),
(4, 4, 'No loud parties or events.'),
(5, 5, 'Must dispose of trash properly.'),
(6, 6, 'Guests must show ID upon check-in.'),
(7, 7, 'No parties or events allowed.'),
(8, 8, 'Maximum 2 guests per room.'),
(9, 9, 'Keep noise to a minimum after 9 PM.'),
(10, 10, 'No smoking in the building.'),
(11, 11, 'Check-in after 3 PM.'),
(12, 12, 'Check-out before 11 AM.'),
(13, 13, 'No illegal activities on the premises.'),
(14, 14, 'Do not leave valuables unattended.'),
(15, 15, 'Guests must clean up after themselves.'),
(16, 16, 'Pets are allowed with an extra fee.'),
(17, 17, 'No illegal substances allowed on property.'),
(18, 18, 'Please respect other guests.'),
(19, 19, 'Keep the area around the pool clean.'),
(20, 20, 'Do not disturb neighbors.'),
(21, 21, 'Guests should respect quiet hours.'),
(22, 22, 'No additional guests without approval.'),
(23, 23, 'Do not move furniture without permission.'),
(24, 24, 'Please keep the gate closed.'),
(25, 25, 'No smoking or drinking in public areas.');

-- Neighborhood_Info
INSERT INTO Neighborhood_Info (id, accommodation_id, info_text) VALUES 
(1, 1, 'Close to Times Square and Central Park.'),
(2, 2, 'Near the London Eye and Big Ben.'),
(3, 3, 'Located in a quiet neighborhood, close to Shinjuku.'),
(4, 4, 'Walkable distance to the Eiffel Tower and Louvre Museum.'),
(5, 5, 'Near Berlin’s iconic Brandenburg Gate and Berlin Wall Memorial.'),
(6, 6, 'Just a few minutes from Bondi Beach.'),
(7, 7, 'Close to La Rambla and Gothic Quarter.'),
(8, 8, 'Located in the beautiful Roman countryside, a short drive to the Vatican.'),
(9, 9, 'Situated in a charming neighborhood with canal views.'),
(10, 10, 'Just a short walk to the Hollywood Walk of Fame.'),
(11, 11, 'Close to Retiro Park and the Prado Museum.'),
(12, 12, 'Located near the Ferry Building and Fisherman’s Wharf.'),
(13, 13, 'Located in a peaceful residential area, 20 minutes from downtown Toronto.'),
(14, 14, 'Private beach access, near major shopping malls in Dubai.'),
(15, 15, 'Central location with easy access to Kowloon and the Victoria Harbour.'),
(16, 16, 'A short walk to Insadong and the Namsan Tower in Seoul.'),
(17, 17, 'Situated close to the Grand Palace and Chatuchak Market.'),
(18, 18, 'Located in the heart of Moscow, near the Kremlin and Red Square.'),
(19, 19, 'Close to Marina Bay Sands and Gardens by the Bay.'),
(20, 20, 'Located near Baixa, close to the Tagus River and Alfama district.'),
(21, 21, 'A short walk from Tivoli Gardens and Nyhavn in Copenhagen.'),
(22, 22, 'Located next to Jumeirah Beach and major shopping malls in Dubai.'),
(23, 23, 'Close to the Schönbrunn Palace and Prater Park.'),
(24, 24, 'Located in the vibrant Bairro Alto district in Lisbon.'),
(25, 25, 'In a quiet neighborhood with easy access to Mexico City’s major attractions.');

-- Bookings
INSERT INTO Bookings (id, guest_id, accommodation_id, checkin_date, checkout_date, number_of_guests, status) VALUES 
(1, 1, 1, '2023-12-01', '2023-12-05', 2, 'Confirmed'),
(2, 2, 2, '2023-12-10', '2023-12-15', 3, 'Pending'),
(3, 3, 3, '2023-12-20', '2023-12-25', 1, 'Cancelled'),
(4, 4, 4, '2023-12-05', '2023-12-10', 2, 'Confirmed'),
(5, 5, 5, '2023-12-15', '2023-12-20', 4, 'Confirmed'),
(6, 6, 6, '2023-12-21', '2023-12-25', 6, 'Pending'),
(7, 7, 7, '2023-12-12', '2023-12-17', 2, 'Confirmed'),
(8, 8, 8, '2023-12-01', '2023-12-07', 3, 'Cancelled'),
(9, 9, 9, '2023-12-10', '2023-12-14', 2, 'Confirmed'),
(10, 10, 10, '2023-12-03', '2023-12-08', 5, 'Pending'),
(11, 11, 11, '2023-12-05', '2023-12-10', 4, 'Confirmed'),
(12, 12, 12, '2023-12-02', '2023-12-06', 2, 'Confirmed'),
(13, 13, 13, '2023-12-15', '2023-12-20', 2, 'Cancelled'),
(14, 14, 14, '2023-12-04', '2023-12-09', 5, 'Confirmed'),
(15, 15, 15, '2023-12-16', '2023-12-20', 3, 'Pending'),
(16, 16, 16, '2023-12-18', '2023-12-22', 2, 'Confirmed'),
(17, 17, 17, '2023-12-07', '2023-12-11', 1, 'Confirmed'),
(18, 18, 18, '2023-12-14', '2023-12-18', 3, 'Pending'),
(19, 19, 19, '2023-12-10', '2023-12-14', 4, 'Confirmed'),
(20, 20, 20, '2023-12-03', '2023-12-07', 2, 'Cancelled'),
(21, 21, 21, '2023-12-05', '2023-12-09', 3, 'Confirmed'),
(22, 22, 22, '2023-12-01', '2023-12-06', 4, 'Pending'),
(23, 23, 23, '2023-12-04', '2023-12-08', 2, 'Confirmed'),
(24, 24, 24, '2023-12-20', '2023-12-25', 2, 'Pending'),
(25, 25, 25, '2023-12-15', '2023-12-20', 1, 'Confirmed');

-- Payments
INSERT INTO Payments (id, booking_id, payer_id, payment_method, payment_date, amount, method_id, fee_id) VALUES 
(1, 1, 1, 'Credit Card', '2023-11-20', 480.00, 1, 1),
(2, 2, 2, 'PayPal', '2023-12-01', 1000.00, 2, 2),
(3, 3, 3, 'Bank Transfer', '2023-12-15', 150.00, 3, 3),
(4, 4, 4, 'Credit Card', '2023-12-02', 360.00, 1, 1),
(5, 5, 5, 'PayPal', '2023-12-10', 800.00, 2, 2),
(6, 6, 6, 'Bank Transfer', '2023-12-17', 1320.00, 3, 3),
(7, 7, 7, 'Credit Card', '2023-12-05', 700.00, 1, 1),
(8, 8, 8, 'PayPal', '2023-12-01', 450.00, 2, 2),
(9, 9, 9, 'Bank Transfer', '2023-12-09', 350.00, 3, 3),
(10, 10, 10, 'Credit Card', '2023-12-02', 1750.00, 1, 1),
(11, 11, 11, 'PayPal', '2023-12-06', 520.00, 2, 2),
(12, 12, 12, 'Bank Transfer', '2023-12-02', 260.00, 3, 3),
(13, 13, 13, 'Credit Card', '2023-12-18', 280.00, 1, 1),
(14, 14, 14, 'PayPal', '2023-12-03', 1500.00, 2, 2),
(15, 15, 15, 'Bank Transfer', '2023-12-05', 750.00, 3, 3),
(16, 16, 16, 'Credit Card', '2023-12-07', 240.00, 1, 1),
(17, 17, 17, 'PayPal', '2023-12-12', 120.00, 2, 2),
(18, 18, 18, 'Bank Transfer', '2023-12-08', 690.00, 3, 3),
(19, 19, 19, 'Credit Card', '2023-12-09', 800.00, 1, 1),
(20, 20, 20, 'PayPal', '2023-12-04', 250.00, 2, 2),
(21, 21, 21, 'Bank Transfer', '2023-12-03', 510.00, 3, 3),
(22, 22, 22, 'Credit Card', '2023-12-05', 1200.00, 1, 1),
(23, 23, 23, 'PayPal', '2023-12-09', 420.00, 2, 2),
(24, 24, 24, 'Bank Transfer', '2023-12-11', 640.00, 3, 3),
(25, 25, 25, 'Credit Card', '2023-12-06', 450.00, 1, 1);

-- Reviews
INSERT INTO Reviews (id, guest_id, accommodation_id, rating, review_text, review_date) VALUES 
(1, 1, 1, 5, 'Fantastic stay! Highly recommended.', '2023-12-06'),
(2, 2, 2, 4, 'Great place, but could improve cleanliness.', '2023-12-16'),
(3, 3, 3, 3, 'Good experience, but location was noisy.', '2023-12-26'),
(4, 4, 4, 5, 'Loved this Parisian apartment, very comfortable!', '2023-12-10'),
(5, 5, 5, 4, 'Berlin loft was stylish, but the area was a bit noisy.', '2023-12-12'),
(6, 6, 6, 5, 'Amazing Sydney retreat, the view was incredible!', '2023-12-14'),
(7, 7, 7, 4, 'Great location in Barcelona, but the apartment was a bit small.', '2023-12-18'),
(8, 8, 8, 5, 'Beautiful Roman villa, perfect for a relaxing getaway!', '2023-12-19'),
(9, 9, 9, 4, 'Charming Amsterdam house, but could use better lighting.', '2023-12-02'),
(10, 10, 10, 5, 'Luxury villa in LA, amazing facilities and views.', '2023-12-05'),
(11, 11, 11, 5, 'Madrid apartment was very spacious and well located.', '2023-12-07'),
(12, 12, 12, 4, 'Great condo, but it was a little noisy at night.', '2023-12-09'),
(13, 13, 13, 4, 'Cottage in Toronto was lovely but a bit far from the city.', '2023-12-11'),
(14, 14, 14, 5, 'Stunning penthouse in Dubai, exceeded expectations!', '2023-12-13'),
(15, 15, 15, 3, 'Nice apartment in Hong Kong, but a bit small for the price.', '2023-12-15'),
(16, 16, 16, 5, 'Seoul studio was perfect for our short trip!', '2023-12-17'),
(17, 17, 17, 4, 'Bangkok bungalow was charming but far from the city center.', '2023-12-20'),
(18, 18, 18, 5, 'Moscow apartment was luxurious and well-equipped.', '2023-12-22'),
(19, 19, 19, 4, 'Singapore condo was great, but a bit expensive for the size.', '2023-12-24'),
(20, 20, 20, 5, 'Historic Lisbon studio was perfect for exploring the city.', '2023-12-25'),
(21, 21, 21, 4, 'Copenhagen apartment was small, but the location was fantastic.', '2023-12-03'),
(22, 22, 22, 5, 'Dubai villa was beautiful with excellent service!', '2023-12-04'),
(23, 23, 23, 5, 'Vienna apartment was spacious and well-located.', '2023-12-06'),
(24, 24, 24, 5, 'Lisbon flat was stylish and centrally located.', '2023-12-08'),
(25, 25, 25, 4, 'Mexico City loft was modern and comfortable.', '2023-12-10');

-- Pictures
INSERT INTO Pictures (id, accommodation_id, host_id, guest_id, url, upload_date) VALUES
(1, 1, 1, 1, 'https://example.com/pic1.jpg', '2023-12-01'),
(2, 2, 2, 2, 'https://example.com/pic2.jpg', '2023-12-05'),
(3, 3, 3, 3, 'https://example.com/pic3.jpg', '2023-12-08'),
(4, 4, 4, 4, 'https://example.com/pic4.jpg', '2023-12-10'),
(5, 5, 5, 5, 'https://example.com/pic5.jpg', '2023-12-12'),
(6, 6, 6, 6, 'https://example.com/pic6.jpg', '2023-12-15'),
(7, 7, 7, 7, 'https://example.com/pic7.jpg', '2023-12-16'),
(8, 8, 8, 8, 'https://example.com/pic8.jpg', '2023-12-17'),
(9, 9, 9, 9, 'https://example.com/pic9.jpg', '2023-12-18'),
(10, 10, 10, 10, 'https://example.com/pic10.jpg', '2023-12-20'),
(11, 11, 11, 11, 'https://example.com/pic11.jpg', '2023-12-22'),
(12, 12, 12, 12, 'https://example.com/pic12.jpg', '2023-12-23'),
(13, 13, 13, 13, 'https://example.com/pic13.jpg', '2023-12-25'),
(14, 14, 14, 14, 'https://example.com/pic14.jpg', '2023-12-26'),
(15, 15, 15, 15, 'https://example.com/pic15.jpg', '2023-12-27'),
(16, 16, 16, 16, 'https://example.com/pic16.jpg', '2023-12-28'),
(17, 17, 17, 17, 'https://example.com/pic17.jpg', '2023-12-29'),
(18, 18, 18, 18, 'https://example.com/pic18.jpg', '2023-12-30'),
(19, 19, 19, 19, 'https://example.com/pic19.jpg', '2023-12-31'),
(20, 20, 20, 20, 'https://example.com/pic20.jpg', '2023-12-01'),
(21, 21, 21, 21, 'https://example.com/pic21.jpg', '2023-12-02'),
(22, 22, 22, 22, 'https://example.com/pic22.jpg', '2023-12-03'),
(23, 23, 23, 23, 'https://example.com/pic23.jpg', '2023-12-04'),
(24, 24, 24, 24, 'https://example.com/pic24.jpg', '2023-12-05'),
(25, 25, 25, 25, 'https://example.com/pic25.jpg', '2023-12-06');

-- Languages
INSERT INTO Languages (id, language_name) VALUES
(1, 'English'),
(2, 'Spanish'),
(3, 'French'),
(4, 'German'),
(5, 'Italian'),
(6, 'Japanese'),
(7, 'Mandarin'),
(8, 'Korean'),
(9, 'Portuguese'),
(10, 'Dutch'),
(11, 'Russian'),
(12, 'Arabic'),
(13, 'Turkish'),
(14, 'Swedish'),
(15, 'Czech'),
(16, 'Polish'),
(17, 'Greek'),
(18, 'Hebrew'),
(19, 'Thai'),
(20, 'Hindi'),
(21, 'Danish'),
(22, 'Finnish'),
(23, 'Norwegian'),
(24, 'Romanian'),
(25, 'Hungarian');

-- User_Languages
INSERT INTO User_Languages (user_id, language_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10, 9),
(11, 10),
(12, 11),
(13, 12),
(14, 13),
(15, 14),
(16, 15),
(17, 16),
(18, 17),
(19, 18),
(20, 19),
(21, 20),
(22, 21),
(23, 22),
(24, 23),
(25, 24);

-- Cancellation_Policies
INSERT INTO Cancellation_Policies (id, description) VALUES
(1, 'Free cancellation within 24 hours of booking. After that, 50% charge.'),
(2, 'Free cancellation up to 48 hours before check-in. No refund after that.'),
(3, 'Non-refundable once booked.'),
(4, 'Free cancellation up to 7 days before check-in. No refund after that.'),
(5, 'Full refund if cancelled within 30 days of booking.'),
(6, 'Cancellation with a 20% fee for any time before check-in.'),
(7, 'No cancellations, but you can reschedule for a 10% fee.'),
(8, 'Full refund if cancelled at least 72 hours before check-in.'),
(9, 'Free cancellation up to 24 hours before check-in.'),
(10, 'No refunds after booking, except for medical emergencies.'),
(11, '50% refund if cancelled 48 hours before check-in.'),
(12, 'Full refund if cancelled before 24 hours of check-in.'),
(13, 'Cancellation free up to 3 days prior to check-in.'),
(14, 'Refund within 7 days before the arrival date.'),
(15, 'Non-refundable, but offers a credit for future stays.'),
(16, 'Free cancellation within 72 hours before check-in.'),
(17, 'No cancellations, but offers rescheduling for a fee.'),
(18, 'Refundable if cancelled within 14 days of booking.'),
(19, 'No cancellation, but flexible changes allowed.'),
(20, 'Refundable only if cancelled within 48 hours of booking.'),
(21, 'Cancellation allowed with a 30% fee, no refund after check-in.'),
(22, 'Free cancellation with no penalty 48 hours before check-in.'),
(23, 'Non-refundable, except in extreme circumstances.'),
(24, 'Full refund with 24-hour notice before check-in.'),
(25, 'Refund available with 50% of the cost after 7 days cancellation.');

-- Discounts
INSERT INTO Discounts (id, accommodation_id, discount_percentage, start_date, end_date) VALUES
(1, 1, 10.00, '2023-12-01', '2023-12-15'),
(2, 2, 15.00, '2023-12-05', '2023-12-20'),
(3, 3, 5.00, '2023-12-10', '2023-12-25'),
(4, 4, 20.00, '2023-12-01', '2023-12-31'),
(5, 5, 30.00, '2023-12-15', '2023-12-25'),
(6, 6, 25.00, '2023-12-01', '2023-12-15'),
(7, 7, 10.00, '2023-12-01', '2023-12-10'),
(8, 8, 12.50, '2023-12-05', '2023-12-15'),
(9, 9, 7.00, '2023-12-01', '2023-12-20'),
(10, 10, 15.00, '2023-12-01', '2023-12-30'),
(11, 11, 5.00, '2023-12-10', '2023-12-20'),
(12, 12, 8.00, '2023-12-01', '2023-12-25'),
(13, 13, 18.00, '2023-12-10', '2023-12-30'),
(14, 14, 10.00, '2023-12-03', '2023-12-17'),
(15, 15, 25.00, '2023-12-05', '2023-12-15'),
(16, 16, 20.00, '2023-12-07', '2023-12-20'),
(17, 17, 5.00, '2023-12-10', '2023-12-18'),
(18, 18, 10.00, '2023-12-01', '2023-12-10'),
(19, 19, 8.00, '2023-12-02', '2023-12-14'),
(20, 20, 15.00, '2023-12-01', '2023-12-30'),
(21, 21, 10.00, '2023-12-05', '2023-12-25'),
(22, 22, 30.00, '2023-12-10', '2023-12-20'),
(23, 23, 12.00, '2023-12-02', '2023-12-10'),
(24, 24, 20.00, '2023-12-01', '2023-12-10'),
(25, 25, 15.00, '2023-12-01', '2023-12-15');

-- User_Scores
INSERT INTO User_Scores (id, user_id, rating, rating_date) VALUES
(1, 1, 4, '2023-12-01'),
(2, 2, 5, '2023-12-05'),
(3, 3, 3, '2023-12-08'),
(4, 4, 5, '2023-12-10'),
(5, 5, 4, '2023-12-12'),
(6, 6, 5, '2023-12-15'),
(7, 7, 4, '2023-12-16'),
(8, 8, 5, '2023-12-17'),
(9, 9, 4, '2023-12-18'),
(10, 10, 5, '2023-12-20'),
(11, 11, 5, '2023-12-22'),
(12, 12, 4, '2023-12-23'),
(13, 13, 5, '2023-12-25'),
(14, 14, 5, '2023-12-26'),
(15, 15, 4, '2023-12-27'),
(16, 16, 5, '2023-12-28'),
(17, 17, 4, '2023-12-29'),
(18, 18, 5, '2023-12-30'),
(19, 19, 4, '2023-12-31'),
(20, 20, 5, '2023-12-01'),
(21, 21, 4, '2023-12-02'),
(22, 22, 5, '2023-12-03'),
(23, 23, 4, '2023-12-04'),
(24, 24, 5, '2023-12-05'),
(25, 25, 4, '2023-12-06');

-- Support_Requests
INSERT INTO Support_Requests (id, guest_id, admin_id, accommodation_id, request_type, description, request_date, status) VALUES
(1, 1, 1, 1, 'Technical Issue', 'Wi-Fi not working properly', '2023-12-01', 'Open'),
(2, 2, 2, 2, 'Refund Request', 'Charged incorrectly for cancellation', '2023-12-05', 'Pending'),
(3, 3, 3, 3, 'Refund Request', 'Not happy with the accommodation', '2023-12-08', 'Closed'),
(4, 4, 4, 4, 'General Inquiry', 'Check-in times confusion', '2023-12-10', 'Open'),
(5, 5, 5, 5, 'Technical Issue', 'Air conditioning not working', '2023-12-12', 'Closed'),
(6, 6, 6, 6, 'Refund Request', 'Charged for extra nights', '2023-12-15', 'Pending'),
(7, 7, 7, 7, 'General Inquiry', 'Availability of parking', '2023-12-16', 'Closed'),
(8, 8, 8, 8, 'Technical Issue', 'Heating system malfunction', '2023-12-17', 'Pending'),
(9, 9, 9, 9, 'General Inquiry', 'Check-in assistance required', '2023-12-18', 'Open'),
(10, 10, 10, 10, 'Refund Request', 'Double charge on the bill', '2023-12-20', 'Closed'),
(11, 11, 11, 11, 'General Inquiry', 'How to extend stay', '2023-12-22', 'Open'),
(12, 12, 12, 12, 'Refund Request', 'Noisy neighborhood', '2023-12-23', 'Pending'),
(13, 13, 13, 13, 'Technical Issue', 'Shower water pressure low', '2023-12-25', 'Closed'),
(14, 14, 14, 14, 'General Inquiry', 'Availability of extra bed', '2023-12-26', 'Open'),
(15, 15, 15, 15, 'Technical Issue', 'Kitchen appliances not working', '2023-12-27', 'Pending'),
(16, 16, 16, 16, 'Refund Request', 'Charged for additional services', '2023-12-28', 'Open'),
(17, 17, 17, 17, 'Refund Request', 'Late check-in charge issue', '2023-12-29', 'Closed'),
(18, 18, 18, 18, 'General Inquiry', 'Local attractions recommendations', '2023-12-30', 'Pending'),
(19, 19, 19, 19, 'Technical Issue', 'Wi-Fi outage', '2023-12-31', 'Closed'),
(20, 20, 20, 20, 'General Inquiry', 'Cancellation policy clarification', '2023-12-01', 'Open'),
(21, 21, 21, 21, 'Technical Issue', 'Lightbulb in the bathroom broken', '2023-12-02', 'Closed'),
(22, 22, 22, 22, 'Refund Request', 'Uncomfortable mattress', '2023-12-03', 'Pending'),
(23, 23, 23, 23, 'General Inquiry', 'Availability of room service', '2023-12-04', 'Open'),
(24, 24, 24, 24, 'Technical Issue', 'Leaking faucet', '2023-12-05', 'Closed'),
(25, 25, 25, 25, 'General Inquiry', 'Pets allowed policy', '2023-12-06', 'Open');

-- Payment_Methods
INSERT INTO Payment_Methods (id, method_name, description) VALUES
(1, 'Credit Card', 'Visa, MasterCard, American Express'),
(2, 'PayPal', 'Use PayPal account for transactions'),
(3, 'Bank Transfer', 'Direct bank transfer'),
(4, 'Apple Pay', 'Payment through Apple Pay system'),
(5, 'Google Pay', 'Payment via Google Pay'),
(6, 'Cash', 'Pay directly in cash upon arrival'),
(7, 'Cryptocurrency', 'Bitcoin and other cryptocurrencies accepted'),
(8, 'Alipay', 'Use Alipay for payments'),
(9, 'WeChat Pay', 'Payment through WeChat'),
(10, 'Stripe', 'Stripe payment gateway'),
(11, 'Debit Card', 'MasterCard, Visa debit cards'),
(12, 'Gift Card', 'Use pre-purchased gift cards for payment'),
(13, 'Amazon Pay', 'Payment using Amazon account'),
(14, 'Samsung Pay', 'Use Samsung Pay system'),
(15, 'Payoneer', 'Pay through Payoneer account'),
(16, 'Cash on Arrival', 'Cash payment upon check-in'),
(17, 'Boleto', 'Boleto Bancário payment method (Brazil)'),
(18, 'Direct Debit', 'Direct bank account debit'),
(19, 'Skrill', 'Skrill payment system'),
(20, 'Revolut', 'Payment via Revolut'),
(21, 'Venmo', 'Pay via Venmo'),
(22, 'Zelle', 'Payment via Zelle system'),
(23, 'Western Union', 'Send money through Western Union'),
(24, 'Klarna', 'Pay later with Klarna'),
(25, 'Paytm', 'Payment through Paytm (India)');

-- Transaction_Fees
INSERT INTO Transaction_Fees (id, fee_percentage) VALUES
(1, 3.50),
(2, 4.00),
(3, 2.50),
(4, 5.00),
(5, 3.00),
(6, 4.50),
(7, 2.00),
(8, 3.75),
(9, 4.25),
(10, 3.00),
(11, 2.50),
(12, 3.25),
(13, 3.00),
(14, 4.75),
(15, 5.00),
(16, 2.00),
(17, 3.50),
(18, 4.25),
(19, 2.75),
(20, 3.00),
(21, 4.00),
(22, 3.50),
(23, 3.25),
(24, 2.50),
(25, 4.00);