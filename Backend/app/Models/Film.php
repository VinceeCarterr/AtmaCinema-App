<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Film extends Model
{
    use HasFactory;

    protected $table = 'film';
    protected $primaryKey = 'id_film';
    protected $fillable = [
        'judul_film',
        'durasi',
        'rating_umur',
        'dimensi',
        'tanggal_rilis',
        'genre',
        'sinopsis',
        'producer',
        'director',
        'writers',
        'cast',
        'poster',
        'status',
    ];

    public function jadwal_tayang()
    {
        return $this->hasMany(JadwalTayang::class, 'id_film');
    }

}
