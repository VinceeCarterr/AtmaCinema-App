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
        Schema::create('film', function (Blueprint $table) {
            $table->id();
            $table->string("judul_film");
            $table->integer("durasi");
            $table->string("rating_umur");
            $table->string("dimensi");
            $table->string("tanggal_rilis");
            $table->string("genre");
            $table->string("sinopsis");
            $table->string("producer");
            $table->string("director");
            $table->string("writers");
            $table->string("cast");
            $table->string("poster");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('film');
    }
};
