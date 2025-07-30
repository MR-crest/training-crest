-- Network Address Data Types
-- ###########################

/*
  PostgreSQL provides several data types to store network-related data:
  
  1. inet:
     - Used to store a single IP address (IPv4 or IPv6).
     - Example: '192.168.1.1' (IPv4) or 'fe80::1' (IPv6)
  
  2. cidr:
     - Used to store an IP network (IPv4 or IPv6) with a network mask (subnet).
     - Example: '192.168.1.0/24' (IPv4 network) or '2001:db8::/32' (IPv6 network)
  
  3. macaddr:
     - Used to store MAC (Media Access Control) addresses, which are unique hardware identifiers for network devices.
     - Example: '00:14:22:01:23:45'
  
  4. macaddr8:
     - Used to store an 8-byte MAC address (used for newer, larger address space formats like IEEE 64-bit MAC addresses).
     - Example: '00:14:22:01:23:45:67:89'

  These data types are helpful when working with network configurations, IP addresses, and network routing.
*/

CREATE TABLE table_netaddr(
id SERIAL PRIMARY KEY,
ip INET
);

INSERT INTO table_netaddr(ip) VALUES
('14.35.221.243'),
('14.152.207.126'),
('14.152.207.238'),
('14.249.111.162'),
('12.1.223.132'),
('12.8.192.60');

SELECT * FROM table_netaddr;

SELECT
ip,
set_masklen (ip, 24) as inet_24
FROM table_netaddr;

SELECT
ip,
set_masklen (ip, 24) as inet_24,
set_masklen (ip:: cidr, 24) as cidr_24
FROM table_netaddr;

SELECT
ip,
set_masklen (ip, 24) as inet_24,
set_masklen (ip:: cidr, 24) as cidr_24,
set_masklen (ip:: cidr, 27) as cidr_27,
set_masklen (ip:: cidr, 28) as cidr_28
FROM table_netaddr;