<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use App\Models\Question;
use App\Models\Category;
use App\Models\Language;
use App\Models\Level;
use App\Models\Contest;
use App\Models\Classification;

class QuestionTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Question::insert([
            'category_id' => Category::all()->random()->id,
            'contest_id' => 0,
            'language_id' => 0,
            'level_id' => Level::all()->random()->id,
            'question_level_master_id' => 0,
            'image' => "",
            'question' => "My question goes here?",
            'question_type' => 1,
            'option_a' => "Option A",
            'option_b' => "Option B",
            'option_c' => "Option C",
            'option_d' => "Option D",
            'optione' => "",
            'answer' => 1,
            'note' => "Any Note",
        ]);
    }
}
