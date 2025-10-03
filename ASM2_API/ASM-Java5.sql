create database EasyEat
go

use EasyEat
go

create table Users(
	UserId bigint primary key identity(1000, 1),
	Username nvarchar(32) not null unique,
	Email nvarchar(254) not null unique,
	PasswordHash nvarchar(64) not null,
	CreationDate datetime2(3) not null,
	IsActive bit not null,
	LastLoginDate datetime2(3),
	foreign key (RoleId) references Roles(RoleId)
)
go

create table admins (
	user_id
)

create table customers (
)

create table sellers (
)

create table Categories(
	CategoryId int primary key identity(1, 1),
	CategoryName nvarchar(100)
)
go

create table Products(
	ProductId bigint primary key identity(1000, 1),
	ProductName nvarchar(100) not null,
	Price decimal(10,2) not null,
	StockQuantity int not null,
	ImageUrl nvarchar(500) not null,
	IsActive bit not null,
	ProductDescription nvarchar(1024) not null,
	CategoryId int,
	Specifications nvarchar(max) not null,
	CreationDate datetime2(3) not null,
	foreign key (CategoryId) references Categories(CategoryId)
)
go

create table Cart(
	UserId bigint not null,
	ProductId bigint not null,
	Quantity int not null,
	foreign key (UserId) references Users(UserId) on delete cascade,
	foreign key (ProductId) references Products(ProductId) on delete cascade,
	unique(UserId, ProductId)
)
go

create table Comments (
	CommentId bigint PRIMARY KEY IDENTITY(1,1),
	UserId bigint not null,
	ProductId bigint not null,
	CommentDate datetime2(3) not null,
	CommentContent nvarchar(500) not null,
	foreign key (UserId) references Users(UserId),
	foreign key (ProductId) references Products(ProductId)
)
go

CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
CREATE INDEX IX_Cart_UserId ON Cart(UserId);
CREATE INDEX IX_Comments_ProductId ON Comments(ProductId);

insert into Roles values('User')
insert into Roles values('Manager')
insert into Roles values('Admin')
go

-- categories data (8 tech categories)
insert into Categories values('Laptops')
insert into Categories values('Desktops')
insert into Categories values('Monitors')
insert into Categories values('Keyboards')
insert into Categories values('Mice')
insert into Categories values('Headphones')
insert into Categories values('Graphics cards')
insert into Categories values('Storage')
go

-- users data (25 users, mostly regular users following bell curve)
insert into Users values('Nguyen Le Ngan Ha', 'hanlnts01135@fpt.edu.vn' , '$2a$12$O9moIERfEbHHis5Zes51hO0LUeLDHFpflanUDKLMXGhYAgcEqlRBG', '2024-01-15 10:30:00', 1, 1, '2024-08-09 14:22:00')
insert into Users values('Nguyen Quoc Minh' , 'thnrgbefv0987@gmail.com' , '$2a$12$rnfhc4D/Wxd7jnUSWdpEUeF6wlusVXdOjb/u1QwCnwtec/t6GeYX2', '2024-01-15 10:30:00', 1, 1, '2024-08-09 14:22:00')
insert into Users values('Trinh Thi Linh'   , 'linhttsd@gmail.com '     , '$2a$12$6Lneezy3jribVCUJpYzV/uwJ8kay1ZGjE2adnzs6g0M9RbqEJpZEC', '2024-02-08 09:15:00', 1, 1, '2024-08-08 16:45:00')
insert into Users values('Vo Anh Tuan'      , 'tuanvasd@gmail.com '     , '$2a$12$LpW4G3snr1.auHyur8T6LekqQpJG3Y.jQrCuz7bc0a8xAnM5iUVOu', '2024-02-20 11:45:00', 1, 1, '2024-08-10 08:30:00')
insert into Users values('Nguyen Tan Thanh' , 'thanhntsd@gmail.com'     , '$2a$12$2ETrqO7JiV9tkkjxd/VaWe2OD1Xl90M2.O2h3oT9TJvPcA44vqoP2', '2024-03-05 14:20:00', 1, 1, '2024-08-07 20:15:00')
insert into Users values('Le Thi Mai'       , 'mailtsd@gmail.com'       , '$2a$12$rnfhc4D/Wxd7jnUSWdpEUeF6wlusVXdOjb/u1QwCnwtec/t6GeYX2', '2024-03-12 16:30:00', 1, 1, '2024-08-09 12:00:00')
insert into Users values('Pham Van Duc'     , 'ducpvsd@gmail.com'       , '$2a$12$6Lneezy3jribVCUJpYzV/uwJ8kay1ZGjE2adnzs6g0M9RbqEJpZEC', '2024-03-18 13:45:00', 1, 1, '2024-08-08 10:20:00')
insert into Users values('Tran Thi Hoa'     , 'hoattsd@gmail.com'       , '$2a$12$LpW4G3snr1.auHyur8T6LekqQpJG3Y.jQrCuz7bc0a8xAnM5iUVOu', '2024-03-25 08:00:00', 1, 1, '2024-08-06 15:30:00')
insert into Users values('Hoang Van Long'   , 'longhvsd@gmail.com'      , '$2a$12$2ETrqO7JiV9tkkjxd/VaWe2OD1Xl90M2.O2h3oT9TJvPcA44vqoP2', '2024-04-02 12:15:00', 1, 1, '2024-08-10 11:45:00')
insert into Users values('Nguyen Thi Lan'   , 'lanntsd@gmail.com'       , '$2a$12$rnfhc4D/Wxd7jnUSWdpEUeF6wlusVXdOjb/u1QwCnwtec/t6GeYX2', '2024-04-08 15:30:00', 1, 1, '2024-08-09 18:00:00')
insert into Users values('Vu Van Hung'      , 'hungvvsd@gmail.com'      , '$2a$12$6Lneezy3jribVCUJpYzV/uwJ8kay1ZGjE2adnzs6g0M9RbqEJpZEC', '2024-04-15 09:45:00', 1, 1, '2024-08-07 13:20:00')
insert into Users values('Do Thi Thu'       , 'thudtsd@gmail.com'       , '$2a$12$LpW4G3snr1.auHyur8T6LekqQpJG3Y.jQrCuz7bc0a8xAnM5iUVOu', '2024-04-20 14:00:00', 1, 1, '2024-08-08 09:15:00')
insert into Users values('Bui Van Nam'      , 'nambvsd@gmail.com'       , '$2a$12$2ETrqO7JiV9tkkjxd/VaWe2OD1Xl90M2.O2h3oT9TJvPcA44vqoP2', '2024-04-28 11:30:00', 1, 1, '2024-08-10 16:40:00')
insert into Users values('Luu Thi Nga'      , 'ngaltsd@gmail.com'       , '$2a$12$rnfhc4D/Wxd7jnUSWdpEUeF6wlusVXdOjb/u1QwCnwtec/t6GeYX2', '2024-05-05 10:15:00', 1, 1, '2024-08-09 14:50:00')
insert into Users values('Dang Van Khai'    , 'khaidvsd@gmail.com'      , '$2a$12$6Lneezy3jribVCUJpYzV/uwJ8kay1ZGjE2adnzs6g0M9RbqEJpZEC', '2024-05-12 13:20:00', 1, 1, '2024-08-08 12:30:00')
insert into Users values('jake_code'        , 'jake.code@email.com'     , '$2a$12$rnfhc4D/Wxd7jnUSWdpEUeF6wlusVXdOjb/u1QwCnwtec/t6GeYX2', '2024-05-18 16:45:00', 1, 1, '2024-08-07 17:25:00')
insert into Users values('zoe_art'          , 'zoe.art@email.com'       , '$2a$12$6Lneezy3jribVCUJpYzV/uwJ8kay1ZGjE2adnzs6g0M9RbqEJpZEC', '2024-05-25 12:00:00', 1, 1, '2024-08-10 10:10:00')
insert into Users values('noah_game'        , 'noah.game@email.com'     , '$2a$12$LpW4G3snr1.auHyur8T6LekqQpJG3Y.jQrCuz7bc0a8xAnM5iUVOu', '2024-06-01 08:30:00', 1, 1, '2024-08-09 19:20:00')
insert into Users values('lucy_write'       , 'lucy.write@email.com'    , '$2a$12$2ETrqO7JiV9tkkjxd/VaWe2OD1Xl90M2.O2h3oT9TJvPcA44vqoP2', '2024-06-08 15:15:00', 1, 1, '2024-08-08 14:35:00')
insert into Users values('max_build'        , 'max.build@email.com'     , '$2a$12$rnfhc4D/Wxd7jnUSWdpEUeF6wlusVXdOjb/u1QwCnwtec/t6GeYX2', '2024-06-15 11:20:00', 1, 1, '2024-08-07 11:00:00')
insert into Users values('eva_learn'        , 'eva.learn@email.com'     , '$2a$12$6Lneezy3jribVCUJpYzV/uwJ8kay1ZGjE2adnzs6g0M9RbqEJpZEC', '2024-06-22 14:40:00', 1, 1, '2024-08-10 13:45:00')
insert into Users values('sam_tech'         , 'sam.tech@email.com'      , '$2a$12$LpW4G3snr1.auHyur8T6LekqQpJG3Y.jQrCuz7bc0a8xAnM5iUVOu', '2024-07-01 09:00:00', 1, 1, '2024-08-09 15:50:00')
insert into Users values('amy_work'         , 'amy.work@email.com'      , '$2a$12$2ETrqO7JiV9tkkjxd/VaWe2OD1Xl90M2.O2h3oT9TJvPcA44vqoP2', '2024-07-08 12:30:00', 1, 1, '2024-08-08 18:10:00')
insert into Users values('dan_play'         , 'dan.play@email.com'      , '$2a$12$rnfhc4D/Wxd7jnUSWdpEUeF6wlusVXdOjb/u1QwCnwtec/t6GeYX2', '2024-07-15 16:00:00', 1, 1, '2024-08-07 09:30:00')
insert into Users values('store_manager'    , 'manager@backendstore.com', '$2a$12$6Lneezy3jribVCUJpYzV/uwJ8kay1ZGjE2adnzs6g0M9RbqEJpZEC', '2024-01-01 08:00:00', 2, 1, '2024-08-10 07:00:00')
insert into Users values('system_admin'     , 'admin@backendstore.com'  , '$2a$12$LpW4G3snr1.auHyur8T6LekqQpJG3Y.jQrCuz7bc0a8xAnM5iUVOu', '2024-01-01 08:00:00', 3, 1, '2024-08-10 07:30:00')
go

-- products data (30 products with bell curve pricing around $500-800)
insert into Products values('Gaming laptop rtx 4060'     , 899.99 , 15, 'laptop1.jpg'    , 1, 'powerful gaming laptop with rtx 4060 graphics card perfect for gaming and content creation', 1, '{"cpu": "intel i5-13500h", "ram": "16gb ddr5", "storage": "512gb nvme ssd", "gpu": "rtx 4060 8gb", "display": "15.6 1080p 144hz", "battery": "80wh", "weight": "2.3kg"}', '2024-02-01 10:00:00')
insert into Products values('Budget office laptop'       , 449.99 , 25, 'laptop2.jpg'    , 1, 'affordable laptop for office work and daily tasks with good battery life'                  , 1, '{"cpu": "intel i3-1215u", "ram": "8gb ddr4", "storage": "256gb ssd", "gpu": "intel uhd", "display": "14 1080p", "battery": "50wh", "weight": "1.5kg"}', '2024-02-05 11:30:00')
insert into Products values('Ultrabook pro max'          , 1299.99, 8 , 'laptop3.jpg'    , 1, 'premium ultrabook with excellent build quality and performance'                            , 1, '{"cpu": "intel i7-13700u", "ram": "32gb lpddr5", "storage": "1tb nvme ssd", "gpu": "intel iris xe", "display": "13.3 2k oled", "battery": "75wh", "weight": "1.2kg"}', '2024-02-10 09:15:00')
insert into Products values('Creator workstation'        , 1599.99, 5 , 'laptop4.jpg'    , 1, 'high-end workstation laptop for professional content creators'                             , 1, '{"cpu": "intel i9-13900hx", "ram": "32gb ddr5", "storage": "2tb nvme ssd", "gpu": "rtx 4070 8gb", "display": "16 4k oled", "battery": "99wh", "weight": "2.8kg"}', '2024-02-15 14:20:00')
insert into Products values('Student laptop basic'       , 349.99 , 30, 'laptop5.jpg'    , 1, 'simple laptop perfect for students and basic computing needs'                              , 1, '{"cpu": "amd ryzen 3 7320u", "ram": "8gb ddr4", "storage": "256gb ssd", "gpu": "radeon graphics", "display": "14 1080p", "battery": "45wh", "weight": "1.6kg"}', '2024-02-20 16:45:00')
insert into Products values('Gaming desktop beast'       , 1899.99, 3 , 'desktop1.jpg'   , 1, 'ultimate gaming desktop with top tier components for maximum performance'                  , 2, '{"cpu": "intel i7-14700k", "ram": "32gb ddr5-6000", "storage": "1tb gen4 nvme + 2tb hdd", "gpu": "rtx 4080 16gb", "motherboard": "z790 chipset", "psu": "850w gold", "case": "tempered glass rgb"}', '2024-02-25 12:00:00')
insert into Products values('Office desktop mini'        , 599.99 , 20, 'desktop2.jpg'   , 1, 'compact desktop perfect for office environments and productivity tasks'                    , 2, '{"cpu": "intel i5-13400", "ram": "16gb ddr4", "storage": "512gb nvme ssd", "gpu": "intel uhd 730", "motherboard": "b760 micro-atx", "psu": "500w bronze", "case": "mini-itx compact"}', '2024-03-01 10:30:00')
insert into Products values('Budget build starter'       , 799.99 , 12, 'desktop3.jpg'   , 1, 'great starter desktop for gaming and general use without breaking the bank'                , 2, '{"cpu": "amd ryzen 5 7600", "ram": "16gb ddr5-5200", "storage": "500gb nvme ssd", "gpu": "rx 6600 8gb", "motherboard": "b650 chipset", "psu": "650w bronze", "case": "mid-tower black"}', '2024-03-05 15:45:00')
insert into Products values('4k gaming monitor'          , 649.99 , 18, 'monitor1.jpg'   , 1, 'stunning 4k monitor with hdr support perfect for gaming and content consumption'           , 3, '{"size": "27 inches", "resolution": "3840x2160", "panel": "ips", "refresh_rate": "144hz", "response_time": "1ms", "hdr": "hdr400", "connectivity": "hdmi 2.1, displayport 1.4", "stand": "height adjustable"}', '2024-03-10 11:20:00')
insert into Products values('Ultrawide productivity'     , 899.99 , 10, 'monitor2.jpg'   , 1, 'ultrawide monitor that boosts productivity with massive screen real estate'                , 3, '{"size": "34 inches", "resolution": "3440x1440", "panel": "va curved", "refresh_rate": "100hz", "response_time": "4ms", "hdr": "hdr400", "connectivity": "usb-c, hdmi, displayport", "stand": "ergonomic pivot"}', '2024-03-15 08:50:00')
insert into Products values('Budget 1080p monitor'       , 199.99 , 35, 'monitor3.jpg'   , 1, 'reliable 1080p monitor for everyday computing and light gaming'                            , 3, '{"size": "24 inches", "resolution": "1920x1080", "panel": "ips", "refresh_rate": "75hz", "response_time": "5ms", "hdr": "none", "connectivity": "hdmi, vga", "stand": "tilt only"}', '2024-03-20 13:15:00')
insert into Products values('Mechanical keyboard rgb'    , 129.99 , 40, 'keyboard1.jpg'  , 1, 'premium mechanical keyboard with rgb lighting and tactile switches'                        , 4, '{"switches": "cherry mx blue", "layout": "full size 104 key", "backlighting": "per key rgb", "connectivity": "usb-c wired", "keycaps": "double shot pbt", "features": "hot swappable, aluminum frame"}', '2024-03-25 16:30:00')
insert into Products values('Wireless office keyboard'   , 49.99  , 60, 'keyboard2.jpg'  , 1, 'quiet wireless keyboard perfect for office environments'                                   , 4, '{"switches": "membrane quiet", "layout": "compact 87 key", "backlighting": "white led", "connectivity": "2.4ghz wireless", "battery": "2x aaa 12 month", "features": "spill resistant, low profile"}', '2024-03-30 09:40:00')
insert into Products values('Gaming keyboard compact'    , 89.99  , 28, 'keyboard3.jpg'  , 1, 'compact gaming keyboard with fast switches and customizable lighting'                      , 4, '{"switches": "gateron red linear", "layout": "tkl 87 key", "backlighting": "rainbow rgb", "connectivity": "usb-a wired", "polling": "1000hz", "features": "anti-ghosting, removable cable"}', '2024-04-05 14:25:00')
insert into Products values('Gaming mouse precision'     , 79.99  , 50, 'mouse1.jpg'     , 1, 'high precision gaming mouse with customizable buttons and rgb'                             , 5, '{"sensor": "pixart 3395", "dpi": "25600 max", "buttons": "8 programmable", "connectivity": "usb-a wired", "weight": "85g", "features": "rgb lighting, braided cable, gaming grade switches"}', '2024-04-10 12:10:00')
insert into Products values('Office mouse wireless'      , 29.99  , 80, 'mouse2.jpg'     , 1, 'comfortable wireless mouse for everyday office use'                                        , 5, '{"sensor": "optical 1600dpi", "buttons": "3 button", "connectivity": "2.4ghz wireless", "battery": "1x aa 18 month", "weight": "95g", "features": "ergonomic design, silent clicks"}', '2024-04-15 10:55:00')
insert into Products values('Vertical ergonomic mouse'   , 59.99  , 25, 'mouse3.jpg'     , 1, 'ergonomic vertical mouse designed to reduce wrist strain'                                  , 5, '{"sensor": "optical 2400dpi", "buttons": "6 button", "connectivity": "usb-a wired", "design": "vertical ergonomic", "weight": "120g", "features": "thumb rest, adjustable dpi, right handed"}', '2024-04-20 15:20:00')
insert into Products values('Noise cancelling headphones', 299.99 , 22, 'headphones1.jpg', 1, 'premium noise cancelling headphones with exceptional sound quality'                        , 6, '{"driver": "40mm dynamic", "frequency": "20hz-20khz", "impedance": "32 ohm", "connectivity": "bluetooth 5.3 + 3.5mm", "battery": "30 hour anc", "features": "active noise cancelling, quick charge, voice assistant"}', '2024-04-25 11:35:00')
insert into Products values('Gaming headset 7.1'         , 149.99 , 30, 'headphones2.jpg', 1, 'immersive gaming headset with 7.1 surround sound and rgb lighting'                         , 6, '{"driver": "50mm neodymium", "frequency": "20hz-20khz", "impedance": "64 ohm", "connectivity": "usb-a wired", "microphone": "detachable boom", "features": "7.1 virtual surround, rgb lighting, memory foam"}', '2024-04-30 13:50:00')
insert into Products values('Studio monitor headphones'  , 199.99 , 15, 'headphones3.jpg', 1, 'professional studio monitor headphones for audio production'                               , 6, '{"driver": "45mm planar magnetic", "frequency": "15hz-35khz", "impedance": "150 ohm", "connectivity": "3.5mm + 6.35mm", "cable": "3m detachable", "features": "open back design, flat response, velour pads"}', '2024-05-05 09:25:00')
insert into Products values('Budget earbuds wireless'    , 39.99  , 70, 'headphones4.jpg', 1, 'affordable wireless earbuds with decent sound quality for daily use'                       , 6, '{"driver": "6mm dynamic", "frequency": "20hz-20khz", "connectivity": "bluetooth 5.0", "battery": "6h + 24h case", "features": "ipx4 water resistance, touch controls, auto pairing"}', '2024-05-10 16:15:00')
insert into Products values('Rtx 4070 graphics card'     , 599.99 , 12, 'gpu1.jpg'       , 1, 'powerful graphics card for 1440p gaming and content creation'                              , 7, '{"gpu": "nvidia rtx 4070", "vram": "12gb gddr6x", "base_clock": "1920 mhz", "boost_clock": "2475 mhz", "memory_speed": "21 gbps", "power": "200w tdp", "connectivity": "3x dp 1.4a, 1x hdmi 2.1"}', '2024-05-15 12:40:00')
insert into Products values('Rtx 4080 super flagship'    , 999.99 , 6 , 'gpu2.jpg'       , 1, 'flagship graphics card for 4k gaming and professional workloads'                           , 7, '{"gpu": "nvidia rtx 4080 super", "vram": "16gb gddr6x", "base_clock": "2295 mhz", "boost_clock": "2550 mhz", "memory_speed": "23 gbps", "power": "320w tdp", "connectivity": "3x dp 1.4a, 1x hdmi 2.1"}', '2024-05-20 14:00:00')
insert into Products values('Budget rx 6600 card'        , 279.99 , 20, 'gpu3.jpg'       , 1, 'excellent budget graphics card for 1080p gaming performance'                               , 7, '{"gpu": "amd radeon rx 6600", "vram": "8gb gddr6", "base_clock": "1968 mhz", "boost_clock": "2491 mhz", "memory_speed": "14 gbps", "power": "132w tdp", "connectivity": "3x dp 1.4, 1x hdmi 2.1"}', '2024-05-25 10:30:00')
insert into Products values('1tb nvme ssd gen4'          , 99.99  , 45, 'storage1.jpg'   , 1, 'blazing fast gen4 nvme ssd for system and game storage'                                    , 8, '{"capacity": "1tb", "interface": "pcie gen4 x4", "form_factor": "m.2 2280", "read_speed": "7000 mb/s", "write_speed": "6500 mb/s", "controller": "phison e26", "nand": "3d tlc"}', '2024-05-30 08:45:00')
insert into Products values('2tb external hdd'           , 79.99  , 55, 'storage2.jpg'   , 1, 'portable external hard drive for backup and mass storage'                                  , 8, '{"capacity": "2tb", "interface": "usb 3.2 gen1", "form_factor": "2.5 portable", "rotation": "5400 rpm", "cache": "128mb", "power": "usb powered", "features": "shock resistant, plug and play"}', '2024-06-05 15:10:00')
insert into Products values('4tb nas drive'              , 159.99 , 18, 'storage3.jpg'   , 1, 'reliable nas optimized drive for network attached storage systems'                         , 8, '{"capacity": "4tb", "interface": "sata iii 6gb/s", "form_factor": "3.5 internal", "rotation": "7200 rpm", "cache": "256mb", "mtbf": "1.4m hours", "features": "nas optimized, 24/7 operation"}', '2024-06-10 11:55:00')
insert into Products values('500gb portable ssd'         , 69.99  , 40, 'storage4.jpg'   , 1, 'compact portable ssd for fast file transfers and storage'                                  , 8, '{"capacity": "500gb", "interface": "usb 3.2 gen2", "form_factor": "external portable", "read_speed": "1050 mb/s", "write_speed": "1000 mb/s", "encryption": "256-bit aes", "features": "shock resistant, compact design"}', '2024-06-15 13:20:00')
insert into Products values('Premium gaming setup'       , 2999.99, 2 , 'combo1.jpg'     , 1, 'complete premium gaming setup with top tier components'                                    , 1, '{"cpu": "intel i9-14900k", "ram": "64gb ddr5-6400", "storage": "2tb gen4 nvme", "gpu": "rtx 4090 24gb", "monitor": "32 4k 144hz", "peripherals": "mechanical keyboard + gaming mouse + headset"}', '2024-06-20 16:40:00')
insert into Products values('Office workstation complete', 1499.99, 4 , 'combo2.jpg'     , 1, 'complete office workstation for professional productivity'                                 , 2, '{"cpu": "intel i7-14700", "ram": "32gb ddr5", "storage": "1tb nvme + 2tb hdd", "gpu": "intel uhd 770", "monitor": "27 1440p ips", "peripherals": "wireless keyboard + mouse + webcam"}', '2024-06-25 09:30:00')
go

-- cart data (15 cart entries, some users have multiple items)
insert into Cart values(1000, 1000, 1)
insert into Cart values(1000, 1008, 1)
insert into Cart values(1001, 1003, 1)
insert into Cart values(1002, 1015, 2)
insert into Cart values(1002, 1020, 1)
insert into Cart values(1003, 1001, 1)
insert into Cart values(1004, 1025, 1)
insert into Cart values(1005, 1012, 1)
insert into Cart values(1005, 1016, 1)
insert into Cart values(1006, 1009, 1)
insert into Cart values(1007, 1022, 3)
insert into Cart values(1008, 1004, 1)
insert into Cart values(1009, 1018, 1)
insert into Cart values(1010, 1007, 1)
insert into Cart values(1011, 1014, 2)
go

-- comments data (25 comments with realistic feedback)
insert into Comments values(1000, 1000, '2024-07-15 14:30:00', 'great gaming laptop, runs all my games smoothly at high settings. battery life could be better but thats expected for gaming')
insert into Comments values(1001, 1001, '2024-07-20 09:45:00', 'perfect for office work, lightweight and quiet. exactly what i needed for daily tasks and zoom meetings')
insert into Comments values(1002, 1000, '2024-07-22 16:20:00', 'amazing performance for the price point. the rtx 4060 handles everything i throw at it. definitely recommend')
insert into Comments values(1003, 1008, '2024-07-25 11:15:00', 'this monitor is gorgeous, 4k gaming looks incredible. took a bit to get used to the size but now i cant go back')
insert into Comments values(1004, 1015, '2024-07-28 13:40:00', 'love this mouse, very precise for fps games. the rgb lighting is a nice touch and the software is easy to use')
insert into Comments values(1005, 1012, '2024-08-01 10:25:00', 'solid mechanical keyboard, cherry mx blues feel great to type on. maybe a bit loud for office use but perfect at home')
insert into Comments values(1006, 1009, '2024-08-03 15:50:00', 'ultrawide changed my productivity completely. having multiple windows side by side is so much better than dual monitors')
insert into Comments values(1007, 1020, '2024-08-05 12:10:00', 'decent budget earbuds, sound quality is okay for the price. battery life is pretty good, lasted me all day')
insert into Comments values(1008, 1003, '2024-08-06 18:30:00', 'expensive but worth every penny. build quality is amazing and performance is top notch for professional work')
insert into Comments values(1009, 1017, '2024-08-07 14:15:00', 'these headphones are comfortable for long sessions. noise cancelling works well in the office environment')
insert into Comments values(1010, 1025, '2024-08-08 09:20:00', 'fast ssd, boot times are incredible now. installation was easy and the performance boost is very noticeable')
insert into Comments values(1011, 1002, '2024-08-08 16:45:00', 'good budget desktop for basic tasks. not suitable for gaming but handles office work and browsing perfectly fine')
insert into Comments values(1012, 1022, '2024-08-09 11:35:00', 'powerful gpu, handles 4k gaming like a champ. runs a bit hot under load but performance is excellent')
insert into Comments values(1013, 1004, '2024-08-09 19:10:00', 'way too expensive for what you get. performance is good but there are better value options available')
insert into Comments values(1014, 1016, '2024-08-10 08:25:00', 'ergonomic design really helps with wrist pain. takes some getting used to but much more comfortable for long work days')
insert into Comments values(1015, 1011, '2024-08-10 13:50:00', 'great value monitor for the price. colors are accurate and 75hz is smooth enough for casual gaming')
insert into Comments values(1001, 1018, '2024-07-18 20:30:00', 'studio quality headphones, very flat response. perfect for audio editing and mixing, highly recommend for creators')
insert into Comments values(1000, 1013, '2024-07-30 17:15:00', 'quiet office keyboard, perfect for shared workspaces. wireless connection is stable and battery lasts forever')
insert into Comments values(1016, 1005, '2024-08-02 14:20:00', 'solid desktop build, good performance for 1080p gaming. cable management could be better but overall happy with purchase')
insert into Comments values(1017, 1019, '2024-08-04 10:40:00', 'immersive gaming experience with 7.1 surround. microphone quality is decent and rgb looks cool in dark room')
insert into Comments values(1018, 1024, '2024-08-06 15:25:00', 'reliable budget gpu, handles 1080p gaming well. not the fastest but great value for money, runs cool and quiet')
insert into Comments values(1019, 1026, '2024-08-07 12:55:00', 'portable ssd is super fast and compact. perfect for transferring large files between computers, highly portable')
insert into Comments values(1020, 1001, '2024-08-08 09:30:00', 'simple laptop that does what it needs to do. not fancy but reliable for students and basic computing needs')
insert into Comments values(1021, 1021, '2024-08-09 16:45:00', 'rtx 4070 is a sweet spot for 1440p gaming. runs everything i play at high settings with good frame rates')
insert into Comments values(1022, 1007, '2024-08-10 11:20:00', 'beast of a gaming desktop, handles everything at max settings. a bit overkill for my needs but future proof')
go