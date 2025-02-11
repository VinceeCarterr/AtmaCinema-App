<?php

namespace App\Http\Controllers;

use App\Models\Studio;
use App\Models\Tiket;
use App\Models\JadwalTayang;
use Illuminate\Http\Request;
use Exception;

use Illuminate\Support\Facades\Log;

class StudioController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            $studio  = Studio::all();
            return response()->json([
                "status" => true,
                "message" => "Get Success",
                "data" => $studio
            ], 200);
        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Get Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    
    public function countBookedDate($id, $id_film)
    {
        try {
            $jumlahTiket = Tiket::where('id_jadwal', $id)->sum('jumlah_kursi');
            Log::info('Jumlah tiket: ' . $jumlahTiket);

            $jadwal = JadwalTayang::where('id_jadwal', $id)->first();
            Log::info('Jadwal: ' . $jadwal);

            if (!$jadwal) {
                return response()->json([
                    'status' => false,
                    'message' => 'Schedule not found',
                    'data' => null,
                ], 404);
            }

            $studio = Studio::where('id_studio', $jadwal->id_studio)->first();
            Log::info('Studio: ' . $studio);

            if (!$studio) {
                return response()->json([
                    'status' => false,
                    'message' => 'Studio not found',
                    'data' => null,
                ], 404);
            }

            $kapasitas = $studio->kapasitas;
            Log::info('Kapasitas: ' . $kapasitas);

            $sisa = $kapasitas - $jumlahTiket;
            Log::info('Sisa: ' . $sisa);

            return response()->json([
                'status' => true,
                'message' => 'Total seat fetched successfully',
                'data' => $sisa,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to load seat availability',
                'data' => $e->getMessage(),
            ], 400);
        }
    }



    public function getStudio($id)
    {
        try{
            $studio = Studio::find($id);
            return response()->json([
                "status" => true,
                "message" => "Get Success",
                "data" => $studio
            ], 200);
        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Get Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try{
            $studio = Studio::create($request->all());
            return response()->json([
                "status" => true,
                "message" => "Create Success",
                "data" => $studio
            ], 200);
        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Create Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try{
            $studio = Studio::find($id);
            return response()->json([
                "status" => true,
                "message" => "Get Success",
                "data" => $studio
            ], 200);
        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Get Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try{
            $studio = Studio::find($id);
            $studio->update($request->all());
            return response()->json([
                "status" => true,
                "message" => "Update Success",
                "data" => $studio
            ], 200);
        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Update Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try{
            $studio = Studio::find($id);
            $studio->delete();
            return response()->json([
                "status" => true,
                "message" => "Delete Success",
                "data" => $studio
            ], 200);
        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Delete Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }
}
