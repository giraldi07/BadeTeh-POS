/*
  # Create Point of Sales Schema for Beverage Business

  1. New Tables
    - `categories`
      - `id` (uuid, primary key)
      - `name` (text) - Category name (e.g., Coffee, Tea, Juice)
      - `icon` (text) - Icon identifier for the category
      - `color` (text) - Color code for category display
      - `created_at` (timestamp)
    
    - `products`
      - `id` (uuid, primary key)
      - `category_id` (uuid, foreign key to categories)
      - `name` (text) - Product name
      - `description` (text) - Product description
      - `price` (numeric) - Product price
      - `image_url` (text) - Product image URL
      - `is_available` (boolean) - Stock availability
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `orders`
      - `id` (uuid, primary key)
      - `order_number` (text) - Unique order number
      - `customer_name` (text) - Optional customer name
      - `total_amount` (numeric) - Total order amount
      - `payment_method` (text) - Payment method used
      - `status` (text) - Order status
      - `created_by` (uuid) - Staff who created the order
      - `created_at` (timestamp)
    
    - `order_items`
      - `id` (uuid, primary key)
      - `order_id` (uuid, foreign key to orders)
      - `product_id` (uuid, foreign key to products)
      - `product_name` (text) - Snapshot of product name
      - `quantity` (integer) - Item quantity
      - `price` (numeric) - Price at time of order
      - `subtotal` (numeric) - quantity * price
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to manage POS data
*/

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  icon text DEFAULT 'coffee',
  color text DEFAULT '#3B82F6',
  created_at timestamptz DEFAULT now()
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES categories(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text DEFAULT '',
  price numeric(10, 2) NOT NULL,
  image_url text DEFAULT '',
  is_available boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number text UNIQUE NOT NULL,
  customer_name text DEFAULT '',
  total_amount numeric(10, 2) NOT NULL,
  payment_method text NOT NULL,
  status text DEFAULT 'completed',
  created_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now()
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES products(id),
  product_name text NOT NULL,
  quantity integer NOT NULL,
  price numeric(10, 2) NOT NULL,
  subtotal numeric(10, 2) NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Policies for categories
CREATE POLICY "Anyone can view categories"
  ON categories FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert categories"
  ON categories FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update categories"
  ON categories FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete categories"
  ON categories FOR DELETE
  TO authenticated
  USING (true);

-- Policies for products
CREATE POLICY "Anyone can view products"
  ON products FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert products"
  ON products FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update products"
  ON products FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete products"
  ON products FOR DELETE
  TO authenticated
  USING (true);

-- Policies for orders
CREATE POLICY "Authenticated users can view all orders"
  ON orders FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can create orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update orders"
  ON orders FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete orders"
  ON orders FOR DELETE
  TO authenticated
  USING (true);

-- Policies for order_items
CREATE POLICY "Authenticated users can view order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert order items"
  ON order_items FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Insert sample categories
INSERT INTO categories (name, icon, color) VALUES
  ('Kopi', 'coffee', '#6F4E37'),
  ('Teh', 'cup-soda', '#10B981'),
  ('Jus', 'glass-water', '#F59E0B'),
  ('Smoothie', 'ice-cream-cone', '#EC4899'),
  ('Minuman Soda', 'wine', '#3B82F6')
ON CONFLICT DO NOTHING;

-- Insert sample products
INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Espresso',
  'Kopi espresso klasik dengan rasa kuat',
  25000,
  true
FROM categories c WHERE c.name = 'Kopi'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Cappuccino',
  'Espresso dengan susu steamed dan foam',
  30000,
  true
FROM categories c WHERE c.name = 'Kopi'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Caffe Latte',
  'Espresso dengan lebih banyak susu',
  32000,
  true
FROM categories c WHERE c.name = 'Kopi'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Americano',
  'Espresso dengan air panas',
  28000,
  true
FROM categories c WHERE c.name = 'Kopi'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Teh Tarik',
  'Teh susu khas Malaysia',
  20000,
  true
FROM categories c WHERE c.name = 'Teh'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Teh Hijau',
  'Teh hijau segar',
  18000,
  true
FROM categories c WHERE c.name = 'Teh'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Thai Tea',
  'Teh Thailand dengan susu',
  22000,
  true
FROM categories c WHERE c.name = 'Teh'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Jus Jeruk',
  'Jus jeruk segar asli',
  25000,
  true
FROM categories c WHERE c.name = 'Jus'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Jus Alpukat',
  'Jus alpukat kental',
  28000,
  true
FROM categories c WHERE c.name = 'Jus'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Jus Mangga',
  'Jus mangga manis',
  27000,
  true
FROM categories c WHERE c.name = 'Jus'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Strawberry Smoothie',
  'Smoothie strawberry dengan yogurt',
  35000,
  true
FROM categories c WHERE c.name = 'Smoothie'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Mango Smoothie',
  'Smoothie mangga tropical',
  35000,
  true
FROM categories c WHERE c.name = 'Smoothie'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Coca Cola',
  'Minuman soda cola',
  15000,
  true
FROM categories c WHERE c.name = 'Minuman Soda'
ON CONFLICT DO NOTHING;

INSERT INTO products (category_id, name, description, price, is_available) 
SELECT 
  c.id,
  'Sprite',
  'Minuman soda lemon-lime',
  15000,
  true
FROM categories c WHERE c.name = 'Minuman Soda'
ON CONFLICT DO NOTHING;