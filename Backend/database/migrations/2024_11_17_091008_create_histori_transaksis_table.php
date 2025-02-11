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
        Schema::create('histori_transaksi', function (Blueprint $table) {
            $table->id();
            $table->foreignId("id_user")->constrained("user")->onDelete("cascade");
            $table->foreignId("id_transaksi")->constrained("transaksi")->onDelete("cascade");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('histori_transaksi');
    }
};
