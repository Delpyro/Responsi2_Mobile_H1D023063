<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // GET: Ambil semua data barang
    public function index()
    {
        $products = Product::all();
        return response()->json([
            'status' => true,
            'message' => 'Data ditemukan',
            'data' => $products
        ]);
    }

    // POST: Tambah barang baru
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'price' => 'required|integer',
            'quantity' => 'required|integer',
            'entry_date' => 'required|date',
            'expired_date' => 'required|date',
        ]);

        $product = Product::create($validated);

        return response()->json([
            'status' => true,
            'message' => 'Barang berhasil ditambahkan',
            'data' => $product
        ], 201);
    }

    // GET: Ambil detail 1 barang
    public function show($id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json(['status' => false, 'message' => 'Barang tidak ditemukan'], 404);
        }
        return response()->json(['status' => true, 'data' => $product]);
    }

    // PUT: Update barang
    public function update(Request $request, $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json(['status' => false, 'message' => 'Barang tidak ditemukan'], 404);
        }

        $validated = $request->validate([
            'name' => 'required|string',
            'price' => 'required|integer',
            'quantity' => 'required|integer',
            'entry_date' => 'required|date',
            'expired_date' => 'required|date',
        ]);

        $product->update($validated);

        return response()->json([
            'status' => true,
            'message' => 'Barang berhasil diupdate',
            'data' => $product
        ]);
    }

    // DELETE: Hapus barang
    public function destroy($id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json(['status' => false, 'message' => 'Barang tidak ditemukan'], 404);
        }

        $product->delete();

        return response()->json(['status' => true, 'message' => 'Barang berhasil dihapus']);
    }
}