<?php

namespace App\Http\Controllers;

use App\Models\Transaksi;
use Illuminate\Http\Request;
Use App\Models\User;
use Exception;

class TransaksiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function getTransaksiByUser($id)
    {
        try {
            $data =
                Transaksi::select(
                    'transaksi.id_transaksi',
                    'film.id_film',
                    'film.judul_film',
                    'studio.id_studio',
                    'studio.nomor_studio',
                    'jadwal_tayang.tanggal',
                    'jadwal_tayang.jam_tayang'
                )
                ->join('tiket', 'tiket.id_transaksi', '=', 'transaksi.id_transaksi')
                ->join('jadwal_tayang', 'jadwal_tayang.id_jadwal', '=', 'tiket.id_jadwal')
                ->join('film', 'film.id_film', '=', 'jadwal_tayang.id_film')
                ->join('studio', 'studio.id_studio', '=', 'jadwal_tayang.id_studio')
                ->where('transaksi.id_user', $id)
                ->get();

            return response([
                'success' => true,
                'message' => 'Success get transaction user',
                'data' => $data
            ], 200);
        } catch (Exception $e) {
            return response([
                'seccess' => false,
                'message' => 'Failed get transaction ' . $e->getMessage(),
                'data' => []
            ], 500);
        }
    }
    
    public function index()
    {
        try{
            $transaksi = Transaksi::all();
            return response()->json([
                'success' => true,
                'message' => 'Daftar data transaksi',
                'data' => $transaksi
            ], 200);
        }catch(\Exception $e){
            return response()->json([
                'success' => false,
                'message' => 'Gagal',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try{
            $validateData = $request->validate([
                'id_user' => 'required',
                'total_harga' => 'required',
                'status' => 'required'
            ]);

            $userId = $validateData['id_user'];
            $user = User::find($userId);
            if(!$user){
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $transaksi = Transaksi::create($validateData);
            return response()->json([
                'success' => true,
                'message' => 'Transaksi berhasil ditambahkan',
                'data' => $transaksi
            ], 200);
        }catch(Exception $e){
            return response()->json([
                'success' => false,
                'message' => 'Gagal',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Transaksi $transaksi)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Transaksi $transaksi)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Transaksi $transaksi)
    {
        //
    }
}
