<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use App\Models\Pratice_Question;
use App\Models\Category;
use App\Models\Language;
use App\Models\Level;
use App\Models\Classification;

class Pratice_QuestionTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Pratice_Question::insert([
            'category_id' => Category::all()->random()->id,
            'language_id' => 0,
            'level_id' => Level::all()->random()->id,
            'question_level_master_id' => Classification::all()->random()->id,
            'image' => "",
            'question' => "My question goes here?",
            'question_type' => 1,
            'option_a' => "Option A",
            'option_b' => "Option B",
            'option_c' => "Option C",
            'option_d' => "Option D",
            'optione' => "",
            'answer' => "1",
            'note' => "Any Note",
        ]);
    }
}
