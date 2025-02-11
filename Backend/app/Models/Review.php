<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Review extends Model
{
    use HasFactory;

    protected $table = 'review';
    protected $primaryKey = 'id_review';
    protected $fillable = [
        'id_film',
        'id_user',
        'rating_review',
        'deskripsi_review',
    ];

    public function film()
    {
        return $this->belongsTo(Film::class, 'id_film');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }
}
