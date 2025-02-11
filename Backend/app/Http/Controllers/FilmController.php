<?php

namespace App\Http\Controllers;

use App\Models\Film;
use Illuminate\Http\Request;
use Exception;

use Illuminate\Support\Facades\Log;
use App\Models\JadwalTayang;
use Carbon\Carbon;

class FilmController extends Controller
{
    // Menampilkan data film berdasarkan status
    public function indexByStatus($status)
    {
        try {
            $films = Film::where('status', $status)->get();
            return response()->json([
                "status" => true,
                "message" => "Get Success",
                "data" => $films
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Get Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function showFilmSchedule($id_film, $date)
    {
        try {
            if($date == null){
                $scheduleData = JadwalTayang::where('id_film', $id_film)->get();
            }
            else {
                $scheduleData = JadwalTayang::where('id_film', $id_film)->where('tanggal', $date)->get();
            }
    
            return response()->json([
                'status' => true,
                'message' => 'Schedule fetched successfully',
                'data' => $scheduleData,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Get Failed',
                'data' => $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try{
            $film  = Film::all();
            return response()->json([
                "status" => true,
                "message" => "Get Success",
                "data" => $film
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
            dd($request);
            $film = Film::create($request->all());
            return response()->json([
                "status" => true,
                "message" => "Create Success",
                "data" => $film
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
            $film = Film::find($id);
            return response()->json([
                "status" => true,
                "message" => "Get Success",
                "data" => $film
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
            $film = Film::find($id);
            $film->update($request->all());
            return response()->json([
                "status" => true,
                "message" => "Update Success",
                "data" => $film
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
            $film = Film::find($id);
            $film->delete();
            return response()->json([
                "status" => true,
                "message" => "Delete Success",
                "data" => $film
            ], 200);
        }catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Delete Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function search(Request $request)
    {
        try {
            $query = $request->input('query');
            $status = $request->input('status');
        
            $films = Film::where('status', $status)
                ->where('judul_film', 'LIKE', '%' . $query . '%')
                ->get();

            return response()->json([
                "status" => true,
                "message" => "Search Success",
                "data" => $films
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Search Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }
}
