<?php

namespace App\Http\Controllers;

use App\Models\HistoriTransaksi;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Transaksi;
use Exception;

class HistoriTransaksiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    
    public function index()
    {
        try {
            $historiTransaksi = HistoriTransaksi::all();
            if ($historiTransaksi->isEmpty()) {
                return response()->json([
                    'success' => true,
                    'message' => 'Tidak ada histori transaksi',
                    'data' => []
                ], 200);
            }

            return response()->json([
                'success' => true,
                'message' => 'Daftar data histori transaksi',
                'data' => $historiTransaksi
            ], 200);
        } catch (\Exception $e) {
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
                'id_transaksi' => 'required'
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

            $transaksiId = $validateData['id_transaksi'];
            $transaksi = Transaksi::find($transaksiId);
            if(!$transaksi){
                return response()->json([
                    'success' => false,
                    'message' => 'Transaksi tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $historiTransaksi = HistoriTransaksi::create($validateData);
            return response()->json([
                'success' => true,
                'message' => 'Histori transaksi berhasil ditambahkan',
                'data' => $historiTransaksi
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
    public function show($id)
    {
        try{
            $historiTransaksi = HistoriTransaksi::find($id);
            return response()->json([
                'success' => true,
                'message' => 'Detail data histori transaksi',
                'data' => $historiTransaksi
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
     * Update the specified resource in storage.
     */
    public function update(Request $request, HistoriTransaksi $historiTransaksi)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(HistoriTransaksi $historiTransaksi)
    {
        //
    }
}
