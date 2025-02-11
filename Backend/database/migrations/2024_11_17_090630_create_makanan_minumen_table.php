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
        Schema::create('makanan_minuman', function (Blueprint $table) {
            $table->id();
            $table->string("nama_item");
            $table->decimal("harga_item", 10, 2);
            $table->string("deskripsi_item");
            $table->string("kategori");
            $table->string("gambar");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('makanan_minuman');
    }
};
