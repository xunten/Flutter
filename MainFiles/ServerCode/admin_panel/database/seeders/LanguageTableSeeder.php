<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Language;

class LanguageTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Language::truncate();

        $data =  [
            ['language' => 'English', 'lang_code' => 'en',  'status' => '1'],
            ['language' => 'हिन्दी',     'lang_code' => 'hi',  'status' => '0'],
            ['language' => 'ગુજરાતી',    'lang_code' => 'guj', 'status' => '0'],
            ['language' => 'عربي',    'lang_code' => 'ar',  'status' => '0'],
        ];

        Language::insert($data);
    }
}
