<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use App\Models\Contest;
use App\Models\Level;
use Carbon\Carbon;

class ContestTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Contest::insert([
            'name' => "My Contest",
            'start_date' => Carbon::now(),
            'end_date' => Carbon::now(),
            'type' => rand(0, 1),
            'level_id' => Level::all()->random()->id,
            'price' => rand(1, 1000),
            'no_of_user' => rand(1, 20),
            'no_of_user_prize' => rand(1, 20),
            'no_of_rank' => rand(1, 10),
            'total_prize' => rand(1, 15),
            'prize_json' => "Prize Json",
            'status' => 1,
            'image' => "",
        ]);
    }
}
