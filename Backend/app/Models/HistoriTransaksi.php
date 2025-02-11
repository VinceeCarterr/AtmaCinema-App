<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class HistoriTransaksi extends Model
{
    use HasFactory;

    protected $table = 'histori_transaksi';
    protected $primaryKey = 'id_histori';
    protected $fillable = [
        'id_user',
        'id_transaksi',
    ];
    
    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function transaksi()
    {
        return $this->belongsTo(Transaksi::class, 'id_transaksi');
    }
}
