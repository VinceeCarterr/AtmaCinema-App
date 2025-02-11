<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Studio extends Model
{
    use HasFactory;

    protected $table = 'studio';
    protected $primaryKey = 'id_studio';
    protected $fillable = [
        'nomor_studio',
        'kapasitas',
    ];

    public function jadwal_tayang()
    {
        return $this->hasMany(JadwalTayang::class, 'id_studio');
    }
}
