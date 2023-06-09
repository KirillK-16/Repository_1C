
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаОбработка = РеквизитФормыВЗначение("Объект");
	
	СписокПоказателей = ЭтаОбработка.СписокПоказателей();
	Для Каждого Показатель Из СписокПоказателей Цикл
		
		СтрокаПоказателей = ВозможныеПоказатели.Добавить();
		СтрокаПоказателей.Показатель = Показатель.Название;
		СтрокаПоказателей.ИмяСправочника = Показатель.НазваниеСправочника;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозможныеПоказателиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РезультатВыбора = Неопределено;
	
	ТД = Элементы.ВозможныеПоказатели.ТекущиеДанные;
	Если ТД <> Неопределено Тогда
		
		РезультатВыбора = Новый Структура("ИмяПоказателя, ИмяСправочника");
		РезультатВыбора.ИмяПоказателя = ТД.Показатель;
		РезультатВыбора.ИмяСправочника = ТД.ИмяСправочника;
		
	КонецЕсли;
	
	ЭтотОбъект.Закрыть(РезультатВыбора);
	
КонецПроцедуры
