<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;

use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $table = 'user';
    protected $primaryKey = 'id_user';
    protected $fillable = [
        'first_name',
        'last_name',
        'email',
        'password',
        'no_telp',
        'gender',
        'tanggal_lahir',
        'profile_picture',
    ];

    public function review()
    {
        return $this->hasMany(Review::class);
    }

    public function historiTransaksi()
    {
        return $this->hasMany(HistoriTransaksi::class);
    }

    public function transaksi()
    {
        return $this->hasMany(Transaksi::class);
    }
}
