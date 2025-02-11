<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class MakananMinuman extends Model
{
    use HasFactory;

    protected $table = 'makanan_minuman';
    protected $primaryKey = 'id_makanan_minuman';
    protected $fillable = [
        'nama_item',
        'harga_item',
        'deskripsi_item',
        'kategori',
        'gambar',
    ];
}
