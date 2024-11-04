<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {   
        $this->call([
            // AdminTableSeeder::class,
            // LanguageTableSeeder::class,
            // GeneralSettingTableSeeder::class,
            // SmtpSettingTableSeeder::class,
            // EarnpointSettingTableSeeder::class,
            // EarnpointTableSeeder::class,

            CategoryTableSeeder::class,
            LevelTableSeeder::class,
            QuestionLevelTableSeeder::class,
            ContestTableSeeder::class,
            NotificationTableSeeder::class,
            PlanSubscriptionTableSeeder::class,
            Pratice_QuestionTableSeeder::class,
            QuestionTableSeeder::class,
            UserTableSeeder::class,
        ]);
    }
}
