<?php

namespace App\Http\Controllers;

use App\Models\Pembayaran;
use Illuminate\Http\Request;
use App\Models\Transaksi;

class PembayaranController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            $pembayaran = Pembayaran::all();
            return response()->json([
                'success' => true,
                'message' => 'Daftar data pembayaran',
                'data' => $pembayaran
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
                'id_transaksi' => 'required',
                'metode_pembayaran' => 'required',
            ]);

            $transaksiId = $validateData['id_transaksi'];
            $transaksi = Transaksi::find($transaksiId);
            if(!$transaksi){
                return response()->json([
                    'success' => false,
                    'message' => 'Transaksi tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $pembayaran = Pembayaran::create([
                'id_transaksi' => $request->id_transaksi,
                'metode_pembayaran' => $request->metode_pembayaran,
                'waktu_pembayaran' => now()
            ]);
            
            return response()->json([
                'success' => true,
                'message' => 'Data pembayaran berhasil disimpan',
                'data' => $pembayaran
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
     * Display the specified resource.
     */
    public function show($id)
    {
        try{
            $pembayaran = Pembayaran::find($id);
            if(!$pembayaran){
                return response()->json([
                    'success' => false,
                    'message' => 'Data pembayaran tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Data pembayaran ditemukan',
                'data' => $pembayaran
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
    public function update(Request $request, Pembayaran $pembayaran)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Pembayaran $pembayaran)
    {
        //
    }
}
