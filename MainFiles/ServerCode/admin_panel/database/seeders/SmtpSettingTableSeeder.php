<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Smtp;

class SmtpSettingTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Smtp::truncate();

        Smtp::create([
            'protocol' => 'smtp123',
            'host' => 'ssl://smtp.gmail.com',
            'port' => '123',
            'user' => 'admin@admin.com',
            'pass' =>  'admin',
            'from_name' => 'DivineTechs',
            'from_email' => 'admin@admin.com',
        ]);
    }
}
