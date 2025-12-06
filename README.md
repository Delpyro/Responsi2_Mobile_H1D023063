[cite_start]Tentu, ini adalah draft **README.md** yang lengkap dan rapi sesuai dengan syarat pengumpulan[cite: 19, 20].

Silakan salin teks di bawah ini ke dalam file `README.md` di root repository GitHub Anda. **Jangan lupa untuk mengisi bagian yang saya beri tanda kurung siku `[...]` seperti Shift dan Link Video.**

-----

# Responsi 2 Mobile Paket 2 (H1D023063)

Aplikasi inventaris supermarket "Abimart" berbasis Mobile (Flutter) dan Backend (Laravel) untuk manajemen data barang kategori makanan.

## 1\. Identitas Diri

| Keterangan | Detail |
| :--- | :--- |
| **Nama** | Muhammad Nabil Putra Monti |
| **NIM** | H1D023063 |
| **Shift Baru** | SHIFT B |
| **Shift Asal** | SHIFT G |

## 2\. Video Demo Aplikasi

Berikut adalah link demo penggunaan aplikasi:
**[TEMPELY LINK VIDEO YOUTUBE/GDRIVE DISINI]**

-----

## 3\. Spesifikasi API

Aplikasi ini menggunakan Backend Laravel dengan autentikasi **Sanctum**.

  * **Base URL:** `http://127.0.0.1:8000/api` (Disesuaikan dengan IP device).

### A. Autentikasi

#### 1\. Register

  * **Endpoint:** `POST /register`
  * **Body:**
    ```json
    {
      "name": "Nama User",
      "email": "user@email.com",
      "password": "password123"
    }
    ```

#### 2\. Login

  * **Endpoint:** `POST /login`
  * **Body:**
    ```json
    {
      "email": "user@email.com",
      "password": "password123"
    }
    ```
  * **Response:** Mengembalikan `access_token` yang wajib digunakan untuk request selanjutnya.

#### 3\. Logout

  * **Endpoint:** `POST /logout`
  * **Header:** `Authorization: Bearer <token>`

### B. Inventaris (Produk)

Semua endpoint di bawah ini memerlukan Header: `Authorization: Bearer <token>`.

#### 1\. Get All Products (Read)

  * **Endpoint:** `GET /products`
  * **Deskripsi:** Mengambil semua data barang.

#### 2\. Create Product (Create)

  * **Endpoint:** `POST /products`
  * **Body:**
    ```json
    {
      "name": "Susu UHT",
      "price": 5000,
      "quantity": 20,
      "entry_date": "2023-12-01",
      "expired_date": "2024-12-01"
    }
    ```

#### 3\. Update Product (Update)

  * **Endpoint:** `PUT /products/{id}`
  * **Body:** (Sama seperti Create Product)

#### 4\. Delete Product (Delete)

  * **Endpoint:** `DELETE /products/{id}`

-----

## 4\. Penjelasan Kode Aplikasi

Berikut adalah penjelasan singkat mengenai fungsi-fungsi utama dalam kode Flutter:

### A. Services (Logika API)

1.  **`api_service.dart`**
      * `ApiConstants`: Kelas statis yang menyimpan Base URL dan endpoint agar mudah dikelola dan diubah (misal ganti IP).
2.  **`auth_service.dart`**
      * `login(email, password)`: Mengirim request POST ke API login dan menyimpan token ke `SharedPreferences` jika sukses.
      * `register(name, email, password)`: Mengirim request POST untuk mendaftarkan user baru.
      * `logout()`: Menghapus request logout ke API dan menghapus token dari penyimpanan lokal HP.
3.  **`product_service.dart`**
      * `getProducts()`: Mengambil list barang dari API dengan menyertakan Bearer Token.
      * `deleteProduct(id)`: Menghapus barang berdasarkan ID tertentu.

### B. Screens (Tampilan UI)

1.  **`login_screen.dart`**
      * Menampilkan form email dan password.
      * Menggunakan `_login()` untuk memanggil `AuthService`. Jika berhasil, user diarahkan ke halaman Home.
2.  **`register_screen.dart`**
      * Menampilkan form registrasi (Nama, Email, Password).
      * Validasi input sebelum dikirim ke API.
3.  **`home_screen.dart`**
      * **Action Bar:** Menampilkan judul "Daftar Inventaris" sesuai syarat soal.
      * **List View:** Menampilkan data barang yang diambil via `_fetchProducts()`.
      * **Delete:** Fitur hapus barang dengan konfirmasi dialog.
      * **Logout:** Tombol di pojok kanan atas untuk keluar aplikasi.
4.  **`add_edit_product_screen.dart`**
      * **Reusability:** Halaman ini digunakan untuk dua fungsi sekaligus (Tambah dan Edit).
      * `_selectDate()`: Memunculkan DatePicker untuk input tanggal masuk/kedaluwarsa.
      * `_submit()`: Mengecek apakah `widget.product` null. Jika null, maka melakukan POST (Tambah). Jika ada datanya, maka melakukan PUT (Edit/Update).

### C. Main

  * **`main.dart`**
      * Mengatur tema aplikasi menjadi warna **Hijau** (`Colors.green`) sesuai syarat soal.
      * Mengecek rute awal aplikasi.