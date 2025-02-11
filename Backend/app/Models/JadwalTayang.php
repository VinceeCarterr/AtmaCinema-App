<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class JadwalTayang extends Model
{
    use HasFactory;

    protected $table = 'jadwal_tayang';
    protected $primaryKey = 'id_jadwal';
    protected $fillable = [
        'id_film',
        'id_studio',
        'tanggal',
        'jam_tayang',
        'harga',
    ];

    public function film()
    {
        return $this->belongsTo(Film::class, 'id_film');
    }

    public function studio()
    {
        return $this->belongsTo(Studio::class, 'id_studio');
    }

    public function tiket()
    {
        return $this->hasMany(Tiket::class, 'id_jadwal');
    }
}
