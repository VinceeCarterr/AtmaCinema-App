<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Tiket extends Model
{
    use HasFactory;

    protected $table = 'tiket';
    protected $primaryKey = 'id_tiket';
    protected $fillable = [
        'id_transaksi',
        'id_jadwal',
        'id_junction_studio_jadwal',
        'jumlah_kursi',
        'id_user',
    ];

    public function transaksi()
    {
        return $this->belongsTo(Transaksi::class, 'id_transaksi');
    }

    public function jadwal_tayang()
    {
        return $this->belongsTo(JadwalTayang::class, 'id_jadwal');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user', 'id_user');
    }
}
