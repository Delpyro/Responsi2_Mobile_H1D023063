<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('name');             // Nama (string) [cite: 12]
            $table->integer('price');           // Harga (int) [cite: 13]
            $table->integer('quantity');        // Jumlah (int) [cite: 14]
            $table->date('entry_date');         // Tanggal Masuk [cite: 15]
            $table->date('expired_date');       // Tanggal Kedaluwarsa [cite: 16]
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
