<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $table = 'tbl_transaction';
    protected $guarded = array();

    public function users()
    {
        return $this->belongsTo(Users::class, 'user_id');
    }
    public function plan_subscription()
    {
        return $this->belongsTo(Subscription_Plan::class, 'plan_subscription_id');
    }

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'plan_subscription_id' => 'integer',
        'transaction_id' => 'string',
        'transaction_amount' => 'string',
        'point' => 'string',
    ];
}
