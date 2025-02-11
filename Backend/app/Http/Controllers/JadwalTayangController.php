<?php

namespace App\Http\Controllers;

use App\Models\JadwalTayang;
use Illuminate\Http\Request;
use App\Models\Film;
use App\Models\Studio;

class JadwalTayangController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            $jadwalTayang = JadwalTayang::all();
            return response()->json([
                'success' => true,
                'message' => 'Daftar data jadwal tayang',
                'data' => $jadwalTayang
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
                'id_film' => 'required',
                'id_studio' => 'required',
                'tanggal' => 'required',
                'jam_tayang' => 'required',
                'harga' => 'required'
            ]);

            $filmId = $validateData['id_film'];
            $film = Film::find($filmId);
            if(!$film){
                return response()->json([
                    'success' => false,
                    'message' => 'Film tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $studioId = $validateData['id_studio'];
            $studio = Studio::find($studioId);
            if(!$studio){
                return response()->json([
                    'success' => false,
                    'message' => 'Studio tidak ditemukan',
                    'data' => ''
                ], 404);
            }


            $jadwalTayang = JadwalTayang::create($validateData);
            return response()->json([
                'success' => true,
                'message' => 'Data jadwal tayang berhasil disimpan',
                'data' => $jadwalTayang
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
            $jadwalTayang = JadwalTayang::find($id);
            return response()->json([
                'success' => true,
                'message' => 'Data jadwal tayang ditemukan',
                'data' => $jadwalTayang
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
    public function update(Request $request, $id)
    {
        try{
            $jadwal = JadwalTayang::find($id);
            if(!$jadwal){
                return response()->json([
                    'success' => false,
                    'message' => 'Data jadwal tayang tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $validateData = $request->validate([
                'id_film' => 'required',
                'id_studio' => 'required',
                'tanggal' => 'required',
                'jam_tayang' => 'required',
                'harga' => 'required'
            ]);

            $filmId = $validateData['id_film'];
            $film = Film::find($filmId);
            if(!$film){
                return response()->json([
                    'success' => false,
                    'message' => 'Film tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $studioId = $validateData['id_studio'];
            $studio = Studio::find($studioId);
            if(!$studio){
                return response()->json([
                    'success' => false,
                    'message' => 'Studio tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $jadwal->update($validateData);
            return response()->json([
                'success' => true,
                'message' => 'Data jadwal tayang berhasil diubah',
                'data' => $jadwal
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
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try{
            $jadwal = JadwalTayang::find($id);
            if(!$jadwal){
                return response()->json([
                    'success' => false,
                    'message' => 'Data jadwal tayang tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $jadwal->delete();
            return response()->json([
                'success' => true,
                'message' => 'Data jadwal tayang berhasil dihapus',
                'data' => $jadwal
            ], 200);
        }catch(\Exception $e){
            return response()->json([
                'success' => false,
                'message' => 'Gagal',
                'data' => $e->getMessage()
            ], 400);
        }
    }
}
