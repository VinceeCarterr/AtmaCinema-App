<?php

namespace App\Http\Controllers;

use App\Models\Tiket;
use Illuminate\Http\Request;
use App\Models\Transaksi;
use App\Models\JadwalTayang;

class TiketController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            $tiket = Tiket::all();
            return response()->json([
                'success' => true,
                'message' => 'Daftar data tiket',
                'data' => $tiket
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
        try {
            $validateData = $request->validate([
                'id_transaksi' => 'required',
                'id_jadwal' => 'required',
                'jumlah_kursi' => 'required',
                'id_user' => 'required|exists:user,id_user'
            ]);

            // Verify transaction and schedule
            $transaksi = Transaksi::find($validateData['id_transaksi']);
            if (!$transaksi) {
                return response()->json([
                    'success' => false,
                    'message' => 'Transaksi tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $jadwal = JadwalTayang::find($validateData['id_jadwal']);
            if (!$jadwal) {
                return response()->json([
                    'success' => false,
                    'message' => 'Jadwal tayang tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            // Create the ticket
            $tiket = Tiket::create($validateData);

            return response()->json([
                'success' => true,
                'message' => 'Tiket berhasil ditambahkan',
                'data' => $tiket
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
     * Display the specified resource.
     */
    public function show($id)
    {
        try {
            $tiket = Tiket::find($id);
            if ($tiket == null) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data tiket tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            // Attach status dynamically
            $jadwal = JadwalTayang::find($tiket->id_jadwal);
            if ($jadwal) {
                $jadwalTayang = new \DateTime($jadwal->tanggal . ' ' . $jadwal->jadwal_tayang);
                $movieEnd = clone $jadwalTayang;
                $movieEnd->modify('+120 minutes');
                $tiket->status = now()->greaterThan($movieEnd) ? 'History' : 'On Progress';
            } else {
                $tiket->status = 'Unknown';
            }

            return response()->json([
                'success' => true,
                'message' => 'Data tiket ditemukan',
                'data' => $tiket
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
     * Update the specified resource in storage.
     */
    public function update(Request $request, Tiket $tiket)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Tiket $tiket)
    {
        //
    }

    public function fetchByUserId($userId)
    {
        try {
            $tiket = Tiket::where('id_user', $userId)
                ->with(['transaksi', 'jadwal_tayang.film', 'jadwal_tayang.studio'])
                ->get();

            if ($tiket->isEmpty()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tidak ada tiket ditemukan untuk pengguna ini',
                    'data' => []
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Daftar tiket untuk pengguna ditemukan',
                'data' => $tiket
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data tiket',
                'data' => $e->getMessage()
            ], 400);
        }
    }
}
