<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use App\Models\Level;

class LevelTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Level::insert([
            'name' => "Level 1",
            'level_order' => 1,
            'score' => 100,
            'win_question_count' => 1,
            'total_question' => 10,
            'status' => 'enable',
        ]);
    }
}
