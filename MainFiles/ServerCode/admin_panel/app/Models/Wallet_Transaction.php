<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Wallet_Transaction extends Model
{
    use HasFactory;

    protected $table = 'tbl_wallet_transaction';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'contest_id' => 'integer',
        'point' => 'string',
    ];
}
