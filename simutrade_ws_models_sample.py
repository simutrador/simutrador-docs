from pydantic import BaseModel
from typing import Literal, Optional, List
from datetime import datetime
from enum import Enum


# --- Enums for safer typing and extensibility ---


class Timeframe(str, Enum):
    one_minute = "1min"
    five_minutes = "5min"
    one_hour = "1h"
    one_day = "1d"


class ExecutionTiming(str, Enum):
    immediate = "immediate"
    next_bar = "next_bar"
    eod = "eod"


class OrderSide(str, Enum):
    buy = "buy"
    sell = "sell"


class OrderType(str, Enum):
    market = "market"
    limit = "limit"


class OrderStatus(str, Enum):
    accepted = "accepted"
    rejected = "rejected"


class TIF(str, Enum):  # Time in Force
    gtc = "gtc"  # Good till cancelled
    eod = "eod"  # End of day
    ioc = "ioc"  # Immediate or cancel


# --- Core WS Envelope (optional for routing) ---


class WSMessage(BaseModel):
    type: str
    data: dict[str, object]


# --- Client → Server Models ---


class InitSessionData(BaseModel):
    session_id: str  # ID used to correlate session logs (chosen by client for tracking purposes)
    symbol: str  # Ticker (e.g. "AAPL", "BTCUSD")
    start: datetime  # Simulation start time (UTC) — client defines scope of interest
    end: datetime  # Simulation end time (UTC)
    timeframe: Timeframe  # Time resolution of simulation ticks
    clock_speed: int  # Speed in ms between ticks (0 = full speed)
    initial_cash: float  # Starting balance
    protocol_version: Optional[str] = (
        "1.0"  # Optional: client specifies for compatibility
    )


class OrderData(BaseModel):
    order_id: str  # Defined by client for tracking (UUID recommended). Server validates uniqueness.
    side: OrderSide
    type: OrderType
    quantity: Optional[int] = None  # Quantity of asset to buy/sell
    amount: Optional[float] = (
        None  # Optional: specify notional amount instead of quantity
    )
    price: Optional[float] = None  # Required if type = limit
    exec_timing: ExecutionTiming = ExecutionTiming.immediate
    tif: TIF = TIF.gtc  # Time in force: when does this order expire?
    stop_loss: Optional[float] = None  # Bracket order: SL trigger price
    take_profit: Optional[float] = None  # Bracket order: TP trigger price


class CancelOrderData(BaseModel):
    order_id: str


# --- Server → Client Models ---


class SessionReadyData(BaseModel):
    session_id: str
    sim_time: datetime


class TickData(BaseModel):
    sim_time: datetime
    bar_id: Optional[str] = None
    is_eod: Optional[bool] = (
        False  # True if this bar is the last one of the session day.
    )
    # Client can use this to perform EOD rebalancing, issue close orders, or flush internal indicators.


class FillData(BaseModel):
    order_id: str
    fill_id: str
    executed_price: float
    executed_quantity: int
    timestamp: datetime


# --- Position and Account Models ---


class Position(BaseModel):
    symbol: str
    quantity: float  # Total units held
    avg_entry: float  # Volume-weighted average entry price
    unrealized_pnl: Optional[float] = None
    # Server includes unrealized PnL only to support account view;
    # client is encouraged to calculate locally if raw prices are available.
    # Excluded if 'privacy_mode' is enabled.


class OrderStatusReport(BaseModel):
    order_id: str
    side: OrderSide
    type: OrderType
    status: OrderStatus
    filled_qty: int
    remaining_qty: int
    price: Optional[float] = None
    submitted_at: datetime
    tif: TIF


class AccountUpdateData(BaseModel):
    cash: float
    equity: float
    positions: List[Position]
    open_orders: List[OrderStatusReport]


class SessionEndData(BaseModel):
    final_equity: float
    duration_sec: float
    total_trades: int
    sharpe_ratio: float
    max_drawdown: float


class ErrorData(BaseModel):
    code: int
    message: str


class OrderAckData(BaseModel):
    order_id: str
    status: OrderStatus


# --- Utility ---


class PingData(BaseModel):
    timestamp: datetime


class PongData(BaseModel):
    timestamp: datetime


# --- Union Types for Dispatching ---

ClientToServerMessages = Literal["init_session", "order", "cancel", "ping"]

ServerToClientMessages = Literal[
    "session_ready",
    "tick",
    "fill",
    "account_update",
    "session_end",
    "error",
    "order_ack",
    "pong",
]
