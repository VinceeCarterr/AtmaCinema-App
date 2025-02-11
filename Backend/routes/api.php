<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\FilmController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\StudioController;
use App\Http\Controllers\MakananMinumanController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\TransaksiController;
use App\Http\Controllers\HistoriTransaksiController;
use App\Http\Controllers\JadwalTayangController;
use App\Http\Controllers\PembayaranController;
use App\Http\Controllers\TiketController;


Route::post('/login', [UserController::class, 'login']);
Route::post('/register/email', [UserController::class, 'registerEmail']);
Route::post('/register/data', [UserController::class, 'registerData']);

Route::get('/film/status/{status}', [FilmController::class, 'indexByStatus']);
Route::get('/film/schedule/{id_film}/{date}', [FilmController::class, 'showFilmSchedule']);
Route::get('/film/search', [FilmController::class, 'search']);

Route::get('/studio/countBookedDate/{id}/{id_film}', [StudioController::class, 'countBookedDate']);


Route::middleware('auth:sanctum')->group(function() {
    Route::middleware('auth:sanctum')->get('/user/profile', [UserController::class, 'getProfile']);
    Route::middleware('auth:sanctum')->post('/user/profile', [UserController::class, 'updateProfile']);

    // Routing untuk menampilkan data film berdasarkan status
    Route::get('/film/status/{status}', [FilmController::class, 'indexByStatus']);
    Route::get('/makanan_minuman/kategori/{kategori}', [MakananMinumanController::class, 'indexByKategori']);
    Route::get('/makanan_minuman/search', [MakananMinumanController::class, 'search']);

    Route::middleware('auth:sanctum')->post('/logout', [UserController::class, 'logout']);

    Route::get('/review/{id}', [ReviewController::class, 'index']);
    
    Route::get('/history/{id}', [HistoriTransaksiController::class, 'index']);
    
    Route::resource('user', UserController::class);
    Route::resource('film', FilmController::class);
    Route::resource('review', ReviewController::class);
    Route::resource('studio', StudioController::class);
    Route::resource('makanan_minuman', MakananMinumanController::class);
    Route::resource('transaksi', TransaksiController::class);
    Route::resource('histori_transaksi', HistoriTransaksiController::class);
    Route::resource('jadwal_tayang', JadwalTayangController::class);
    Route::resource('pembayaran', PembayaranController::class);
    Route::resource('tiket', TiketController::class);

    Route::get('/tiket', [TiketController::class, 'index']);
    Route::get('/tiket/{id}', [TiketController::class, 'show']);
    Route::post('/tiket', [TiketController::class, 'store']);
    Route::get('/tiket/user/{userId}', [TiketController::class, 'fetchByUserId']);
    Route::post('/logout', [UserController::class, 'logout']);
    
    Route::post('/logout', [UserController::class, 'logout']);
});


